module Tradedoc
  module Format
    module UBL
      class Document
        def self.coder_namespaces
          Set[UBL::Coder]
        end

        def self.dump(obj)
          encoding = Encoding::UTF_8.to_s

          builder = Nokogiri::XML::Builder.new(encoding:) do |xml|
            writer = XML::Writer.new(xml, coder_namespaces:)
            writer.render(obj)
          end

          builder.doc
        end

        def self.parse(source)
          xml = case source
          in Nokogiri::XML::Document => doc
            doc
          in String => str
            Nokogiri::XML.parse(str)
          end

          type = [Coder::RemittanceAdvice].detect { it.can_parse?(xml) }
          reader = XML::Reader.new(xml, type.namespaces, coder_namespaces:)
          type.parse(reader)
        end
      end
    end
  end
end
