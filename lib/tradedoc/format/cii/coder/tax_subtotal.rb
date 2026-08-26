module Tradedoc
  module Format
    module CII
      module Coder
        class TaxSubtotal
          def self.ruby_type
            Model::TaxSubtotal
          end

          def self.dump(w, obj, as: "ram:ApplicableTradeTax")
            w.add(as) do
              w.render(obj.tax_amount, as: "ram:CalculatedAmount")
              w.render(obj.tax_category.tax_scheme, as: "ram:TypeCode")
              w.render(obj.taxable_amount, as: "ram:BasisAmount")
              w.render(obj.tax_category.code.edifact_id, as: "ram:CategoryCode")
              w.render(obj.tax_category.rate_percent, as: "ram:RateApplicablePercent")
            end
          end

          def self.parse(r, default_currency: nil)
            ruby_type.new.tap do |obj|
              obj.tax_category ||= Model::TaxCategory.new

              r.parse("ram:CalculatedAmount", :Money, default_currency:) { obj.tax_amount = it }
              r.parse("ram:TypeCode", :String) { obj.tax_category.tax_scheme = it }
              r.parse("ram:BasisAmount", :Money, default_currency:) { obj.taxable_amount = it }
              r.parse("ram:CategoryCode", :String) { obj.tax_category.code = it }
              r.parse("ram:RateApplicablePercent", :BigDecimal) { obj.tax_category.rate_percent = it }
            end
          end
        end
      end
    end
  end
end
