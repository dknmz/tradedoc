module Tradedoc
  module Format
    module UBL
      module Coder
        class TaxSubtotal
          def self.ruby_type
            Model::TaxSubtotal
          end

          def self.dump(w, obj, as: "cac:TaxSubtotal")
            w.add(as) do
              w.render(obj.taxable_amount, as: "TaxableAmount")
              w.render(obj.tax_amount, as: "TaxAmount")
              w.render(obj.tax_category, as: "cac:TaxCategory")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |subtotal|
              r.parse("cbc:TaxableAmount", :Money) { subtotal.taxable_amount = it }
              r.parse("cbc:TaxAmount", :Money) { subtotal.tax_amount = it }
              r.parse("cac:TaxCategory", :TaxCategory) { subtotal.tax_category = it }
            end
          end
        end
      end
    end
  end
end
