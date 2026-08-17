module Tradedoc
  module Model
    class TaxBreakdown < Base
      # [BT-110] Tax total for the whole document
      has :total_tax, Money

      has_many :subtotals, TaxSubtotal
    end
  end
end
