module Tradedoc
  module Model
    class InvoiceLine < Base
      # [BT-126] Unique ID for the invoice line within the invoice itself
      has :id, String

      # [BT-127]
      has :note, String

      # [BT-129]
      has :invoiced_quantity, BigDecimal

      # [BT-131] Total after discounts and charges, excluding vat
      has :total_excluding_tax, Money

      # [BT-153] Required
      has :name, String

      # [BT-154]
      has :description, String

      # [BG-29] Price breakdown / details
      has :price, Price
    end
  end
end
