module Tradedoc
  module XML
    # Wrapper for a `Nokogiri::XML::Builder` that creates an interface for common
    # build actions, namely rendering "components" easily.
    class Writer
      # @param xml [Nokogiri::XML::Builder]
      # @param format [Module]
      #   Any module responding to `.coder_for` and returning a coder.
      #   In reality, should be one of the `Tradedoc.coders`
      def initialize(xml, format:)
        @xml = xml
        @format = format
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

        coder_class = self.format.coder_for(coder_ref || obj.class)
        coder_class.dump(self, obj, **opts)
      end

      private

      attr_reader :xml, :format
    end
  end
end
