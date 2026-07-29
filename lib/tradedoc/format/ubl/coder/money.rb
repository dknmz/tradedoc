module Tradedoc
  module Format
    module UBL
      module Coder
        class Money
          def self.ruby_type
            ::Money
          end

          def self.dump(w, obj, as:, decimals: 2)
            as_string = obj.to_d.round(decimals).to_s("F")
            w.add("cbc:#{as}", as_string, currencyID: obj.currency.iso_code)
          end

          def self.parse(r)
            ruby_type.from_amount(BigDecimal(r.text), r.attribute!("currencyID"))
          end
        end
      end
    end
  end
end
