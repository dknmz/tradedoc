module Tradedoc
  module Model
    class FinancialAccount < Base
      # Identifies the kind of account numbering scheme
      # Documentation for this is hard to come by. "IBAN" is for sure one of them,
      # and "SWIFT" and "SWIFTBIC" have both been observed in samples and docs
      has :scheme_name, String

      # [BT-84]
      has :account_number, String

      # [BT-85]
      has :name, String

      # Only necessary for non-IBAN
      has :financial_institution, FinancialInstitution
    end
  end
end
