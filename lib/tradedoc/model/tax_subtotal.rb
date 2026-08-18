module Tradedoc
  module Model
    class TaxSubtotal < Base
      # [BT-116] Amount subject to tax
      has :taxable_amount, Money

      # [BT-117] Amount taxed in this category
      has :tax_amount, Money

      has :tax_category, TaxCategory
    end
  end
end
