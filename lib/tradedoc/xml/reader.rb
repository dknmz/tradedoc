module Tradedoc
  module XML
    # Provides an XML reading experience similar to the `Nokogiri::XML::Builder`
    # experience where you can traverse a document by selecting nodes without
    # having to constantly do `nil` checks and assign ephemeral variables.
    class Reader
      attr_reader :node, :namespaces, :format

      # @param node [Nokogiri::XML::Node]
      #   XML::Document is also considered a node
      # @param namespaces [Hash]
      #   Namespaces *with aliases* to use when reading the document.
      #  	You must not rely on namespace aliases defined in the source document
      #   since they can easily be different to what you expect.
      #   Define a list of all namespaces you'll read from with aliases.
      #
      #   { "xmlns:foo" => "urn:example:Foo", "xmlns:bar" => "urn:example:Bar" }
      # @param format [Module]
      #   The format to use for parsing.
      #   Must repond to `.coder_for(type)` to get a coder for a destination type.
      def initialize(node, namespaces = {}, format:)
        @node = node
        @namespaces = namespaces
        @format = format
      end

      # If a node exists at the given xpath, yield a reader for that node.
      # This avoids the pattern nil-checking every single read operation.
      #
      # This pattern of swapping-out the current node makes reading XML similar
      # to building a document with Nokogiri.
      #
      # @example
      #   reader = Reader.new(Nokogiri::XML.parse(str))
      #   obj = Person.new
      #
      #   reader.with_node("Person") do
      #     obj.id = reader.at_xpath("ID").text
      #     reader.with_node("Address") do
      #       obj.address.city = reader.at_xpath("City").text
      #     end
      #   end
      #
      # @param input [String | Nokogiri::XML::Node] XPath or Node
      def with_node(input)
        previous_node = node

        next_node = case input
        in ::String => xpath
          at_xpath(xpath)
        in Nokogiri::XML::Node => n
          n
        end

        if next_node.nil?
          return
        end

        @node = next_node
        yield
      ensure
        @node = previous_node
      end

      # Given an xpath that matches 0 or more nodes, maps each element using
      # the given block. The block will reference the current node.
      #
      # @example
      #   r.with_nodes("LineItem") do
      #     Model::LineItem.new(description: r.at_xpath("Description").text)
      #   end
      #   => [Model::LineItem, Model::LineItem...]
      def with_nodes(xpath, &block)
        previous_node = node

        self.xpath(xpath).map do |current|
          @node = current
          yield
        end
      ensure
        @node = previous_node
      end

      # Given an xpath and a type coder class, if that node exists, parse it into
      # an instance of the "real" type we want out of this node.
      # Yields the parsed value so that callers can do something with it if
      # the given node is present
      #
      # @example
      #   r.parse("udt:IssueDate", :Date) { doc.issue_date = it }
      #
      # @param xpath [String]
      # @param coder_ref [Class | Symbol]
      #   Any class that responds to `.parse(r)` where r is this `Reader`
      # @param opts [Hash] Options to pass to the underlying parser
      # @return [Object | nil]
      def parse(xpath, coder_ref, **opts)
        coder_class = self.format.coder_for(coder_ref)
        node_exists = false
        value = with_node(xpath) do
          node_exists = true
          coder_class.parse(self, **opts)
        end

        # Allows parse callers to do something with the parsed value e.g.
        # parse("//node", Address) { some_obj.address = it }
        if block_given? && node_exists
          yield value
        else
          value
        end
      end

      def parse_list(xpath, coder_ref, **opts)
        coder_class = self.format.coder_for(coder_ref)

        values = with_nodes(xpath) do
          coder_class.parse(self, **opts)
        end

        if block_given?
          yield values
        end

        values
      end

      def text
        node.text
      end

      def at_xpath(path)
        node.at_xpath(path, namespaces)
      end

      def xpath(path)
        node.xpath(path, namespaces)
      end

      def attribute(name)
        attribute!(name)
      rescue KeyError
        nil
      end

      def attribute!(name)
        node.attributes.fetch(name).text
      end
    end
  end
end
