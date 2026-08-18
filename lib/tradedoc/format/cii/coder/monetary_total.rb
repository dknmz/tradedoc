module Tradedoc
  module Format
    module CII
      module Coder
        class MonetaryTotal
          def self.ruby_type
            Model::MonetaryTotal
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.line_items_tax_exclusive, as: "ram:LineTotalAmount")
              w.render(obj.tax_breakdown.total_tax, as: "ram:TaxTotalAmount")
              w.render(obj.tax_inclusive, as: "ram:GrandTotalAmount")
              w.render(obj.payable, as: "ram:DuePayableAmount")
            end
          end

          def self.parse(r, **opts)
            ruby_type.new.tap do |mt|
              r.parse("ram:LineTotalAmount", :Money, **opts) { mt.line_items_tax_exclusive = it }
              r.parse("ram:TotalTaxAmount", :Money, **opts) do
                mt.tax_breakdown ||= Model::TaxBreakdown.new
                mt.tax_breakdown.total_tax = it
              end
              r.parse("ram:GrandTotalAmount", :Money, **opts) { mt.tax_inclusive = it }
              r.parse("ram:DuePayableAmount", :Money, **opts) { mt.payable = it }
            end
          end
        end
      end
    end
  end
end
