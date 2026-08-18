module Tradedoc
  module Model
    class Invoice < Base
      is_document

      # [BT-1]
      has :invoice_number, String

      # [BT-2]
      has :issue_date, Date

      # [BT-3]
      has :invoice_type_code, String

      # [BT-5]
      has :currency_code, String

      # [BT-9]
      has :due_date, Date

      # [BT-10] Identifier created by the buyer for internal routing e.g. cost centre
      #   If you're looking for a PO number, see BT-13
      has :buyer_reference, String

      # [BT-13] PO number created by the buyer for three-way matching.
      has :purchase_order_number, String

      # [BT-22]
      has :note, String
      has :payment_means, PaymentMeans

      # [BG-5]
      has :invoice_period, Period

      # [BG-7]
      has :supplier, TradeParty

      # [BG-10]
      has :buyer, TradeParty

      # [BG-17]
      has :payment_means, PaymentMeans

      # [BG-22]
      has :monetary_total, MonetaryTotal

      # [BG-23]
      has :tax_breakdown, TaxBreakdown

      # [BG-25]
      has_many :lines, InvoiceLine
      alias line_items lines
    end
  end
end
