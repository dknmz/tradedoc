module Tradedoc
  module Format
    module UBL
      module Coder
        class MonetaryTotal
          def self.ruby_type
            Model::MonetaryTotal
          end

          def self.dump(w, obj, as: "cac:LegalMonetaryTotal")
            w.add(as) do
              w.render(obj.line_items_tax_exclusive, as: "cbc:LineExtensionAmount")
              w.render(obj.tax_exclusive, as: "cbc:TaxExclusiveAmount")
              w.render(obj.tax_inclusive, as: "cbc:TaxInclusiveAmount")
              w.render(obj.discounts, as: "cbc:AllowanceTotalAmount")
              w.render(obj.charges, as: "cbc:ChargeTotalAmount")
              w.render(obj.prepaid, as: "cbc:PrepaidAmount")
              w.render(obj.rounding, as: "cbc:PayableRoundingAmount")
              w.render(obj.payable, as: "cbc:PayableAmount")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |mt|
              r.parse("cbc:LineExtensionAmount", :Money) { mt.line_items_tax_exclusive = it }
              r.parse("cbc:TaxExclusiveAmount", :Money) { mt.tax_exclusive = it }
              r.parse("cbc:TaxInclusiveAmount", :Money) { mt.tax_inclusive = it }
              r.parse("cbc:AllowanceTotalAmount", :Money) { mt.discounts = it }
              r.parse("cbc:ChargeTotalAmount", :Money) { mt.charges = it }
              r.parse("cbc:PrepaidAmount", :Money) { mt.prepaid = it }
              r.parse("cbc:PayableRoundingAmount", :Money) { mt.rounding = it }
              r.parse("cbc:PayableAmount", :Money) { mt.payable = it }
            end
          end
        end
      end
    end
  end
end
