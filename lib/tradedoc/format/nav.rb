module Tradedoc
  module Format
    # Current Hungarian e-invoice format
    module NAV
      extend Accessors
      extend Finders
      extend XMLSerialization

      module Coder
        class Invoice
          NS = {
            "xmlns" => "http://schemas.nav.gov.hu/OSA/3.0/data",
            "xmlns:base" => "http://schemas.nav.gov.hu/OSA/3.0/base",
            "xmlns:common" => "http://schemas.nav.gov.hu/NTCA/1.0/common"
          }.freeze

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
