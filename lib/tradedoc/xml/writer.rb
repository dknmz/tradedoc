module Tradedoc
  module XML
    # Wrapper for a `Nokogiri::XML::Builder` that creates an interface for common
    # build actions, namely rendering "components" easily.
    class Writer
      # @param xml [Nokogiri::XML::Builder]
      # @param coder_namespaces [Array<Module>]
      #   List of Ruby namespaces where coder objects can be found.
      #   There should be one coder class for each model.
      #   For example, to encode a `Model::TradeParty`, you'd want `Format::Foo::Coder::TradeParty`
      #   and set the `coder_namespaces` to `[Format::Foo::Coder]`
      def initialize(xml, coder_namespaces:)
        @xml = xml
        @coder_namespaces = coder_namespaces
      end

      # Directly adds an element to the document without any processing.
      # Normally with a Nokogiri builder you'd do `xml["ns"].ElemName(text)`
      # but with this you'd do `writer.add("ns:ElemName", value)`
      def add(name, ...)
        xml.public_send(name, ...)
      end

      # Given an object, figure out how to dump/render it into the XML builder.
      #
      # If the given object/value is `nil`, nothing is rendered. No empty element.
      # Otherwise, a coder is looked-up and used for the given type.
      # Assumes that the de-namespaced class name has a matching local coder.
      #   e.g. `Tradedoc::Model::Country` rendered by `Tradedoc::Format::UBL::Coder::Country`
      def render(obj, coder_ref = nil, **opts)
        return if obj.nil?

        coder_class = coder_for(coder_ref, obj)
        if coder_class.nil?
          raise NoCoderError, "couldn't find a coder for '#{obj.class.name}'"
        end

        coder_class.dump(self, obj, **opts)
      end

      private

      attr_reader :xml, :coder_namespaces

      def coder_for(coder_ref, obj)
        case coder_ref
        in Class => coder if coder.respond_to?(:dump)
          coder
        in Symbol => type_name
          coder_by_name(type_name)
        in nil
          coder_for_object(obj)
        end
      end

      def coder_for_object(obj)
        type_name = obj.class.name.split("::").last.to_sym
        coder_by_name(type_name)
      end

      def coder_by_name(type_name)
        coder_namespaces
          .lazy
          .filter_map { |ns| ns.const_defined?(type_name) && ns.const_get(type_name) }
          .first
      end
    end
  end
end
