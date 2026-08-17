module Tradedoc
  module Format
    module CII
      module Coder
        class MonetaryTotal
          def self.ruby_type
            Model::MonetaryTotal
          end

          def self.dump(w, obj)
            raise NotImplementedError
          end

          def self.parse(r, **opts)
            ruby_type.new.tap do |mt|
              r.parse("ram:LineTotalAmount", :Money, **opts) { mt.line_items_tax_exclusive = it }
              r.parse("ram:GrandTotalAmount", :Money, **opts) { mt.tax_inclusive = it }
              r.parse("ram:DuePayableAmount", :Money, **opts) { mt.payable = it }
            end
          end
        end
      end
    end
  end
end
