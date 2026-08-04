module Tradedoc
  module Format
    module UBL
      module Coder
        class ExchangeRate
          def self.ruby_type
            Model::ExchangeRate
          end

          def self.dump(w, obj, as: "cac:ExchangeRate")
            w.add(as) do
              w.render(obj.source_currency_code, as: "cbc:SourceCurrencyCode")
              w.render(obj.target_currency_code, as: "cbc:TargetCurrencyCode")
              w.render(obj.market_id, as: "cbc:ExchangeMarketID")
              w.render(obj.rate, as: "cbc:CalculationRate")
              w.render(obj.date, as: "Date")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |xr|
              r.parse("cbc:SourceCurrencyCode", :String) { xr.source_currency_code = it }
              r.parse("cbc:TargetCurrencyCode", :String) { xr.target_currency_code = it }
              r.parse("cbc:CalculationRate", :BigDecimal) { xr.rate = it }
              r.parse("cbc:ExchangeMarketID", :String) { xr.market_id = it }
              r.parse("cbc:Date", :Date) { xr.date = it }
            end
          end
        end
      end
    end
  end
end
