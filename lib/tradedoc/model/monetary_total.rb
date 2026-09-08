module Tradedoc
  module Model
    # [BG-22] Totals for a document
    class MonetaryTotal < Base
      # [BT-106] Sum of all line items' net amounts. No tax.
      #   (quantity * unit price) - line-level discounts
      has :line_items_tax_exclusive, Money

      # [BT-107] Document-level discounts (aka allowances) e.g. "10% off everything"
      has :discounts, Money

      # [BT-108] Document-level charges e.g. shipping, processing
      has :charges, Money

      # [BT-109] aka. net amount
      has :tax_exclusive, Money

      has :tax_breakdown, TaxBreakdown

      # [BT-112]
      has :tax_inclusive, Money

      # [BT-113] Money already paid by the buyer *before* this. e.g. deposits
      has :prepaid, Money

      # [BT-114] Adjustment of a few cents to reconcile discrepancies caused by rounding.
      has :rounding, Money

      # [BT-115] The actual total amount remaining to be paid by the buyer
      #   tax_exclusive - prepaid + rounding
      has :payable, Money
    end
  end
end
