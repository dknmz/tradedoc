module Tradedoc
  module Model
    class FinancialAccount < Base
      # e.g. IBAN, SWIFT
      # Unclear if this is matched/validated against a list anywhere.
      has :scheme_name, String

      # [BT-84]
      has :account_number, String

      # [BT-85]
      has :name, String

      # [BT-86] BIC or NCC (e.g. routing number) of the account
      has :service_provider_id, String
    end
  end
end
