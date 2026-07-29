module Tradedoc
  module Model
    class FinancialAccount < Base
      # e.g. IBAN
      # Unclear if this is matched/validated against a list anywhere.
      has :scheme_name, String

      has :account_number, String
    end
  end
end
