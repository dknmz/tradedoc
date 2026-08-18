module Tradedoc
  module Format
    module UBL
      module Coder
        class TaxCategory
          def self.ruby_type
            Model::TaxCategory
          end

          def self.dump(w, obj, as: "cac:TaxCategory")
            w.add(as) do
              w.render(obj.code.edifact_id, as: "cbc:ID")
              w.render(obj.rate_percent, as: "cbc:Percent")
              w.render(obj.exemption_reason_code, as: "cbc:TaxExemptionReasonCode")
              w.render(obj.exemption_reason, as: "cbc:TaxExemptionReason")
              if (tax_scheme = obj.tax_scheme)
                w.add("cac:TaxScheme") do
                  w.render(tax_scheme, as: "cbc:ID")
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |cat|
              r.parse("cbc:ID", :String) { cat.code = it }
              r.parse("cbc:Percent", :BigDecimal) { cat.rate_percent = it }
              r.parse("cbc:TaxExemptionReason", :String) { cat.exemption_reason = it }
              r.parse("cbc:TaxExemptionReasonCode", :String) { cat.exemption_reason_code = it }
              r.parse("cac:TaxScheme/cbc:ID", :String) { cat.tax_scheme = it }
            end
          end
        end
      end
    end
  end
end
