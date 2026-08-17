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

          # @param default_currency [String]
          #   Documents specify a top-level currency that indicate a default.
          #   Money amount fields may not include the currency code as attributes,
          #   so in those cases we'll fall-back to the document currency.
          def self.parse(r, default_currency: nil)
            iso_code = r.attribute("currencyID") || default_currency
            ruby_type.from_amount(BigDecimal(r.text), iso_code)
          end
        end
      end
    end
  end
end
