module Tradedoc
  module Format
    # Czechia
    module ISDOC
      extend Accessors
      extend Finders
      extend XMLSerialization

      def self.file_extensions
        Set[".isdoc"]
      end

      module Coder
        class Invoice
          NS = {
            "xmlns" => "http://isdoc.cz/namespace/2013"
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
