module Tradedoc
  module Format
    module ZugferdV1
      module Coder
        class Invoice
          NS = {
            "xmlns:ram" => "urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12",
            "xmlns:rsm" => "urn:ferd:CrossIndustryDocument:invoice:1p0",
            "xmlns:udt" => "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15"
          }
          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns:rsm")
          end

          def self.dump(w, obj)
            raise NotImplementedError
          end

          def self.parse(r)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
