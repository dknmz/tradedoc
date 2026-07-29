module Tradedoc
  module Model
    class RemittanceAdviceLine < Base
      has :id, String
      has :uuid, String
      has :note, String

      # Original amount due.
      # Not supported by CII
      has :debit_amount, Money

      # If there's any offset/credit to apply. Usually 0.
      # Not supported by CII
      has :credit_amount, Money

      # Actual amount being paid.
      has :balance_amount, Money

      has :billing_reference, BillingReference
    end
  end
end
