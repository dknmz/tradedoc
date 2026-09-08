module Tradedoc
  module Format
    # Spanish e-invoice format.
    # No actual support implemented yet, just detection.
    module FacturaE
      extend Accessors
      extend Finders
      extend XMLSerialization

      def self.file_extensions
        Set[".xml", ".xsig"]
      end

      module Coder
        class Invoice
          # Each revision of the spec gets its own namespace.
          # `NS` is for building current-spec documents.
          # `OTHER_NS` is for detecting legacy versions that can still be parsed.
          NS = {
            "xmlns" => "http://www.facturae.gob.es/formato/Versiones/Facturaev3_2_2.xml"
          }.freeze

          OTHER_NS = Set[
            "http://www.facturae.es/Facturae/2007/v3.0/Facturae",
            "http://www.facturae.es/Facturae/2009/v3.2/Facturae",
            "http://www.facturae.es/Facturae/2014/v3.2.1/Facturae"
          ].freeze

          private_constant :NS, :OTHER_NS

          def self.namespaces
            NS
          end

          def self.can_parse?(xmldoc)
            root_ns = xmldoc.root.namespace&.href
            namespaces.fetch("xmlns") == root_ns || OTHER_NS.include?(root_ns)
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
