module Tradedoc
  module Format
    module CII
      module Coder
        class Invoice
          NS = {
            "xmlns:qdt" => "urn:un:unece:uncefact:data:standard:QualifiedDataType:100",
            "xmlns:ram" => "urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100",
            "xmlns:rsm" => "urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100",
            "xmlns:udt" => "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
          }.freeze
          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns:rsm")
          end

          def self.ruby_type
            Model::Invoice
          end

          def self.dump(w, obj)
            raise NotImplementedError
          end

          def self.parse(r)
            ruby_type.new.tap do |inv|
              r.with_node("rsm:CrossIndustryInvoice") do
                r.with_node("rsm:ExchangedDocument") do
                  r.parse("ram:ID", :String) { inv.invoice_number = it }
                  r.parse("ram:TypeCode", :String) { inv.invoice_type_code = it }
                  r.parse("ram:IssueDateTime", :Date) { inv.issue_date = it }
                  r.parse("ram:IncludedNote", :String) { inv.note = it }
                end

                r.with_nodes("rsm:SupplyChainTradeTransaction") do
                  r.with_node("ram:ApplicableHeaderTradeSettlement") do
                    r.parse("ram:PaymentReference", :String) { inv.purchase_order_number = it }
                    r.parse("ram:InvoiceCurrencyCode", :String) { inv.currency_code = it }
                    r.with_node("ram:SpecifiedTradePaymentTerms") do
                      r.parse("ram:DueDateDateTime", :Date) { inv.due_date = it }
                    end
                    r.parse(
                      "ram:SpecifiedTradeSettlementHeaderMonetarySummation",
                      :MonetaryTotal,
                      default_currency: inv.currency_code
                    ) { inv.monetary_total = it }

                    inv.tax_breakdown = Model::TaxBreakdown.new.tap do |tb|
                      default_currency = inv.currency_code

                      r.with_node("ram:SpecifiedTradeSettlementHeaderMonetarySummation") do
                        r.parse("ram:TaxTotalAmount", :Money, default_currency:) { tb.total_tax = it }
                      end

                      r.parse_list("ram:ApplicableTradeTax", :TaxSubtotal, default_currency:) { tb.subtotals = it }
                    end
                  end

                  # It seems common or normal in CII docs to omit the currency code for money attributes
                  # which is fair enough considering the document specifies a currency code.
                  default_currency = inv.currency_code

                  r.with_node("ram:ApplicableHeaderTradeAgreement") do
                    r.parse("ram:SellerTradeParty", :TradeParty) { inv.supplier = it }
                    r.parse("ram:BuyerTradeParty", :TradeParty) { inv.buyer = it }
                  end

                  r.with_nodes("ram:IncludedSupplyChainTradeLineItem") do
                    line = Model::InvoiceLine.new
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
                      r.parse("ram:Name", :String) { line.name = it }
                    end
                    r.with_node("ram:SpecifiedLineTradeDelivery") do
                      r.parse("ram:BilledQuantity", :BigDecimal) { line.invoiced_quantity = it }
                    end
                    r.with_node("ram:SpecifiedTradeSettlementLineMonetarySummation") do
                      r.parse("ram:LineTotalAmount", :Money, default_currency:) { line.total_excluding_tax = it }
                    end

                    line.price = price
                    inv.lines.push(line)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
