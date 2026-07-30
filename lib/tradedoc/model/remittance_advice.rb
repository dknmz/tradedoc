module Tradedoc
  module Model
    class RemittanceAdvice < Base
      has :id, String
      has :uuid, String
      has :issue_date, Date
      has :note, String
      has :buyer, TradeParty
      has :supplier, TradeParty
      has :total_payment_amount, Money
      has :invoice_period, Period
      has :payment_means, PaymentMeans

      has_many :lines, RemittanceAdviceLine
    end
  end
end
