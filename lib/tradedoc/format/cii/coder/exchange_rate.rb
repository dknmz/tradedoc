module Tradedoc
  module Format
    module CII
      module Coder
        class ExchangeRate
          def self.ruby_type
            Model::ExchangeRate
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.source_currency_code, as: "SourceCurrencyCode")
              w.render(obj.target_currency_code, as: "TargetCurrencyCode")
              w.render(obj.market_id, as: "MarketID")
              w.render(obj.rate, as: "ConversionRate")
              w.render(obj.date, as: "ConversionRateDateTime")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |xr|
              r.parse("ram:SourceCurrencyCode", :String) { xr.source_currency_code = it }
              r.parse("ram:TargetCurrencyCode", :String) { xr.target_currency_code = it }
              r.parse("ram:MarketID", :String) { xr.market_id = it }
              r.parse("ram:ConversionRate", :BigDecimal) { xr.rate = it }
              r.parse("ram:ConversionRateDateTime", :Date) { xr.date = it }
            end
          end
        end
      end
    end
  end
end
