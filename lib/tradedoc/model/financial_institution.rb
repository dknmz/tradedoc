module Tradedoc
  module Model
    class FinancialInstitution < Base
      # For SWIFT, this is the BIC
      # For national clearing systems, this is the member ID e.g. US Routing, UK Sort
      has :id, String

      has :national_clearing_system, Code::NationalClearingSystem
    end
  end
end
