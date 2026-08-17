module Tradedoc
  module Format
    # Legacy Hungarian invoice format that still appears embedded in PDFs on occasion.
    # We're unlikely to implement support for it, but being able to detect it is a nice feature.
    module APEH
      extend Accessors
      extend Finders
      extend XMLSerialization

      module Coder
        class Invoice
          NS = {
            "xmlns" => "http://www.apeh.hu/2005/szamla"
          }
          private_constant :NS

          def self.namespaces
            NS
          end

          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns")
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
