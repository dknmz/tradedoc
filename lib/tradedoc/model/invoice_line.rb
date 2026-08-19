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

      has :product, Product

      # [BG-29] Price breakdown / details
      has :price, Price

      # UBL and CII deal with line-level tax differently.
      # UBL has a `TaxTotal` at the line level with the amount under it,
      # then under `Item` has the `ClassifiedTaxCategory`, so they're totally separate.
      #
      # CII by contrast uses one `ApplicableTradeTax` element for `TaxSubtotal` which
      # combines the total tax and tax category into one.
      # To make access easier, we'll store the amount and category separately and then
      # have accessors for reading and writing as a `TaxSubtotal`.
      has :total_tax, Money

      def tax_subtotal
        TaxSubtotal.new(tax_amount: total_tax, tax_category: product.tax_category).freeze
      end

      def tax_subtotal=(ts)
        if (total_tax = ts.tax_amount)
          self.total_tax = total_tax
        end

        if (tax_category = ts.tax_category)
          product.tax_category = tax_category
        end
      end
    end
  end
end
