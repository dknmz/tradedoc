module Tradedoc
  module Format
    module CII
      module Coder
        class Money
          def self.ruby_type
            ::Money
          end

          def self.dump(w, obj, as:)
            formatted = obj.to_d.to_s("F")
            w.add(as, formatted, currencyID: obj.currency.iso_code)
          end

          def self.parse(r)
            iso_code = r.attribute("currencyID")
            ruby_type.from_amount(BigDecimal(r.text), iso_code)
          end
        end
      end
    end
  end
end
