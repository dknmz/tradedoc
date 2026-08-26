module Tradedoc
  module Format
    module CII
      module Coder
        class InvoiceLine
          def self.ruby_type
            Model::InvoiceLine
          end

          def self.dump(w, obj)
            w.add("ram:IncludedSupplyChainTradeLineItem") do
              w.add("ram:AssociatedDocumentLineDocument") do
                w.render(obj.id, as: "ram:LineID")
              end

              w.add("ram:SpecifiedTradeProduct") do
                w.render(obj.product.seller_assigned_id, as: "ram:SellerAssignedID")
                w.render(obj.product.name, as: "ram:Name")
                w.render(obj.product.description, as: "ram:Description")
              end

              w.add("ram:SpecifiedLineTradeAgreement") do
                if (gross = obj.price.gross)
                  w.add("ram:GrossPriceProductTradePrice") do
                    w.render(gross, as: "ram:ChargeAmount")
                  end
                end

                if (net = obj.price.net)
                  w.add("ram:NetPriceProductTradePrice") do
                    w.render(net, as: "ram:ChargeAmount")
                  end
                end
              end

              w.add("ram:SpecifiedLineTradeDelivery") do
                w.render(obj.invoiced_quantity, as: "ram:BilledQuantity")
              end

              w.add("ram:SpecifiedLineTradeSettlement") do
                w.render(obj.tax_subtotal)
                w.add("ram:SpecifiedTradeSettlementLineMonetarySummation") do
                  w.render(obj.total_excluding_tax, as: "ram:LineTotalAmount")
                end
              end
            end
          end

          def self.parse(r, default_currency: nil)
            line = ruby_type.new
            price = Model::Price.new

            r.parse("ram:AssociatedDocumentLineDocument/ram:LineID", :String) { line.id = it }
            r.with_node("ram:SpecifiedLineTradeAgreement") do
              r.with_node("ram:GrossPriceProductTradePrice") do
                r.parse("ram:ChargeAmount", :Money, default_currency:) { price.gross = it }
              end
              r.with_node("ram:NetPriceProductTradePrice") do
                r.parse("ram:ChargeAmount", :Money, default_currency:) { price.net = it }
              end
            end
            r.with_node("ram:SpecifiedTradeProduct") do
              line.product = Model::Product.new.tap do |product|
                r.parse("ram:SellerAssignedID", :String) { product.seller_assigned_id = it }
                r.parse("ram:Name", :String) { product.name = it }
                r.parse("ram:Description", :String) { product.description = it }
              end
            end
            r.with_node("ram:SpecifiedLineTradeDelivery") do
              r.parse("ram:BilledQuantity", :BigDecimal) { line.invoiced_quantity = it }
            end

            r.with_node("ram:SpecifiedLineTradeSettlement") do
              r.parse("ram:ApplicableTradeTax", :TaxSubtotal) { line.tax_subtotal = it }
              r.with_node("ram:SpecifiedTradeSettlementLineMonetarySummation") do
                r.parse("ram:LineTotalAmount", :Money, default_currency:) { line.total_excluding_tax = it }
              end
            end

            line.price = price

            line
          end
        end
      end
    end
  end
end
