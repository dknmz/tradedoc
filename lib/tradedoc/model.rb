module Tradedoc
  module Model
  end
end

require_relative "model/base"

# no dependencies
require_relative "model/country"
require_relative "model/period"
require_relative "model/financial_account"

# depends on others. order may matter
require_relative "model/address"
require_relative "model/trade_party"
require_relative "model/document_reference"
require_relative "model/billing_reference"
require_relative "model/payment_means"
require_relative "model/remittance_advice_line"
require_relative "model/remittance_advice"
