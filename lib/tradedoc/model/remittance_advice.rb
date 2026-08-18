module Tradedoc
  module Model
    class RemittanceAdvice < Base
      is_document

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
      alias_method :line_items, :lines
    end
  end
end
