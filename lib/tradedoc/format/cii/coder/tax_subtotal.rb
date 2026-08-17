module Tradedoc
  module Format
    module CII
      module Coder
        class TaxSubtotal
          def self.ruby_type
            Model::TaxSubtotal
          end

          def self.dump(w, obj)
            raise NotImplementedError
          end

          def self.parse(r, default_currency: nil)
            ruby_type.new.tap do |obj|
              r.parse("ram:CalculatedAmount", :Money, default_currency:) { obj.tax_amount = it }
              r.parse("ram:TypeCode", :String) { obj.tax_scheme = it }
              r.parse("ram:BasisAmount", :Money, default_currency:) { obj.taxable_amount = it }
              r.parse("ram:CategoryCode", :String) { obj.category_code = it }
              r.parse("ram:RateApplicablePercent", :BigDecimal) { obj.rate_percent = it }
            end
          end
        end
      end
    end
  end
end
