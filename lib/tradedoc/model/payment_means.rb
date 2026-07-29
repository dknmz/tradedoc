module Tradedoc
  module Model
    class PaymentMeans < Base
      has :type_code, Code::PaymentMeansType

      # Multiple formats call these "Payer" and "Payee", but it's too easy to
      # miss that single character difference which obviously makes a huge difference.
      # Opt for the obviously distinctive naming.
      has :sending_account, FinancialAccount
      has :receiving_account, FinancialAccount

      has :payment_id, String
      has :instruction_id, String
    end
  end
end
