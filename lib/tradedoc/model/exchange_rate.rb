module Tradedoc
  module Model
    class ExchangeRate < Base
      has :source_currency_code, String
      has :target_currency_code, String

      # e.g. 1 USD = 0.92 EU, calculation rate is 0.92
      has :rate, BigDecimal

      # FX date
      has :date, Date

      # Where did the exchange rate come from?
      has :market_id, String
    end
  end
end
