module Tradedoc
  module Format
    # Greece
    module MyData
      extend Accessors
      extend Finders
      extend XMLSerialization

      def self.label
        "myDATA"
      end

      module Coder
        class Invoice
          NS = {
            "xmlns" => "http://www.aade.gr/myDATA/invoice/v1.0",
            "xmlns:icls" => "https://www.aade.gr/myDATA/incomeClassificaton/v1.0",
            "xmlns:ecls" => "https://www.aade.gr/myDATA/expensesClassificaton/v1.0"
          }.freeze

          private_constant :NS

          def self.namespaces
            NS
          end

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
