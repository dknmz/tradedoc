module Tradedoc
  module Format
    module FatturaPA
      module Coder
        class Invoice
          NS = {
            "xmlns:p" => "http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
          }
          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns:p")
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
