module Tradedoc
  module Model
    class RemittanceAdviceLine < Base
      has :id, String
      has :uuid, String
      has :note, String

      has :document_reference, DocumentReference

      # Original amount due.
      # Not supported by CII
      has :debit_amount, Money

      # If there's any offset/credit to apply. Usually 0.
      # Not supported by CII
      has :credit_amount, Money

      # Actual amount being paid.
      has :balance_amount, Money

      has :exchange_rate, ExchangeRate
    end
  end
end
