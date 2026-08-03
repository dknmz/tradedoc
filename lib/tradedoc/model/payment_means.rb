module Tradedoc
  module Model
    class PaymentMeans < Base
      # [BT-81]
      has :type_code, Code::PaymentMeansType

      # Multiple formats call these "Payer" and "Payee", but it's too easy to
      # miss that single character difference which obviously makes a huge difference.
      # Opt for the obviously distinctive naming.
      has :sending_account, FinancialAccount

      # [BG-18]
      has :receiving_account, FinancialAccount

      # [BT-83]
      has :payment_id, String

      has :instruction_id, String
    end
  end
end
