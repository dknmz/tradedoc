module Tradedoc
  module Format
    module UBL
      module Coder
        class TaxSubtotal
          def self.ruby_type
            Model::TaxSubtotal
          end

          def self.dump(w, obj)
            raise NotImplementedError
          end

          def self.parse(r)
            ruby_type.new.tap do |subtotal|
              r.parse("cbc:TaxableAmount", :Money) { subtotal.taxable_amount = it }
              r.parse("cbc:TaxAmount", :Money) { subtotal.tax_amount = it }
              r.with_node("cac:TaxCategory") do
                r.parse("cbc:ID", :String) { subtotal.category_code = it }
                r.parse("cbc:Percent", :BigDecimal) { subtotal.rate_percent = it }
                r.parse("cbc:TaxExemptionReason", :String) { subtotal.exemption_reason = it }
                r.parse("cbc:TaxExemptionReasonCode", :String) { subtotal.exemption_reason_code = it }
                r.parse("cac:TaxScheme/cbc:ID", :String) { subtotal.tax_scheme = it }
              end
            end
          end
        end
      end
    end
  end
end
