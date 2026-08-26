module Tradedoc
  module Format
    module KSEF
      module Coder
        class Invoice
          NS = {
            "xmlns" => "http://crd.gov.pl/wzor/2025/06/25/13775/",
            "xmlns:etd" => "http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2022/01/05/eD/DefinicjeTypy/"
          }
          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace&.href == namespaces.fetch("xmlns")
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
