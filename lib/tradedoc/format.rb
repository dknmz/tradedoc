module Tradedoc
  module Format
    module Accessors
      # User-friendly label for this format.
      # @return [String]
      def label
        name.split("::").last
      end

      # List of classes that can dump and parse Ruby objects to/from XML
      # @return [Array<Class>]
      def coders
        ns = self::Coder

        ns.constants.filter_map do |const_name|
          val = ns.const_get(const_name)
          if val.respond_to?(:dump) && val.respond_to?(:parse)
            val
          end
        end
      end

      # List of coders that are document types.
      # These are the only ones that can be read/written to/from XML properly.
      #
      # @return [Array<Class>]
      def document_coders
        coders.select { it.respond_to?(:namespaces) && it.respond_to?(:can_parse?) }
      end
    end

    module Finders
      # Given a Ruby type, get the coder class for it.
      #
      # @param coder_ref [Symbol | Class]
      #   symbol: "bare" name of a type like :Date, :BigDecimal, :TradeParty
      #   class: one of:
      #     - Ruby type like `::Date` or `Model::TradeParty` to encode
      #     - A valid coder class (responds to .dump and .parse)
      # @return [Class]
      def coder_for(coder_ref)
        matches = case coder_ref
        in Class => coder if coders.include?(coder)
          [coder]
        in Class => ruby_type
          coders.select { it.ruby_type == ruby_type }
        in Symbol => type_sym
          coders.select { it.ruby_type.name.split("::").last == type_sym.to_s }
        end

        if matches.none?
          raise "couldn't find a coder for '#{coder_ref}'"
        end

        # This shouldn't happen unless there's a misconfigure in this library itself.
        if matches.count > 1
          raise "found multiple coders for #{coder_ref}: #{matches}"
        end

        matches[0]
      end

      def detect_document_coder(xmldoc)
        document_coders.detect { it.can_parse?(xmldoc) }
      end
    end

    module XMLSerialization
      # @param obj [Class] A document-level model to serialize
      # @return [Nokogiri::XML::Document]
      def dump(obj)
        encoding = Encoding::UTF_8.to_s
        builder = Nokogiri::XML::Builder.new(encoding:) do |xml|
          writer = XML::Writer.new(xml, format: self)
          writer.render(obj)
        end
        builder.doc
      end

      # Given an XML document (as an object or string), detect the type
      # and parse it into a model
      #
      # @param source [Nokogiri::XML::Document | String]
      # @param coder [Class] If the coder is already known
      # @return [Object] Model instance
      def parse(source, coder: nil)
        xml = Tradedoc.xml_from(source)
        coder ||= detect_document_coder(xml)
        reader = XML::Reader.new(xml, coder.namespaces, format: self)
        coder.parse(reader)
      end
    end
  end
end

require_relative "format/cii"
require_relative "format/ubl"
