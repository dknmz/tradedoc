module Tradedoc
  module Model
  end
end

require_relative "model/base"

# no dependencies
require_relative "model/contact"
require_relative "model/country"
require_relative "model/country_subdivision"
require_relative "model/exchange_rate"
require_relative "model/financial_institution"
require_relative "model/monetary_total"
require_relative "model/period"
require_relative "model/price"
require_relative "model/tax_subtotal"

# depends on others. order may matter
require_relative "model/address"
require_relative "model/financial_account"
require_relative "model/trade_party"
require_relative "model/document_reference"
require_relative "model/payment_means"
require_relative "model/tax_breakdown"

require_relative "model/remittance_advice_line"
require_relative "model/remittance_advice"

require_relative "model/invoice_line"
require_relative "model/invoice"
