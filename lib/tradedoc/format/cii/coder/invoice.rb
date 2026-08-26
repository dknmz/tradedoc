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
            xmldoc.root.namespace&.href == namespaces.fetch("xmlns:rsm")
          end

          def self.ruby_type
            Model::Invoice
          end

          def self.dump(w, obj)
            w.add("rsm:CrossIndustryInvoice", NS) do
              if (spec_id = obj.specification_id)
                w.add("rsm:ExchangedDocumentContext") do
                  w.add("ram:GuidelineSpecifiedDocumentContextParameter") do
                    w.render(spec_id, as: "ram:ID")
                  end
                end
              end

              w.add("rsm:ExchangedDocument") do
                w.render(obj.invoice_number, as: "ram:ID")
                w.render(obj.invoice_type_code, as: "ram:TypeCode")
                w.render(obj.issue_date, as: "ram:IssueDateTime")
                if (note = obj.note)
                  w.add("ram:IncludedNote") do
                    w.add("ram:Content", note)
                  end
                end
              end

              w.add("rsm:SupplyChainTradeTransaction") do
                w.render_list(obj.lines)

                w.add("ram:ApplicableHeaderTradeAgreement") do
                  w.render(obj.supplier, as: "ram:SellerTradeParty")
                  w.render(obj.buyer, as: "ram:BuyerTradeParty")
                end

                w.add("ram:ApplicableHeaderTradeDelivery")

                w.add("ram:ApplicableHeaderTradeSettlement") do
                  w.render(obj.purchase_order_number, as: "ram:PaymentReference")
                  w.render(obj.currency_code, as: "ram:InvoiceCurrencyCode")

                  w.render_list(obj.monetary_total&.tax_breakdown&.subtotals)

                  w.add("ram:SpecifiedTradePaymentTerms") do
                    w.render(obj.due_date, as: "ram:DueDateDateTime")
                  end
                  w.render(obj.monetary_total, as: "ram:SpecifiedTradeSettlementHeaderMonetarySummation")
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |inv|
              r.with_node("rsm:CrossIndustryInvoice") do
                r.with_node("rsm:ExchangedDocumentContext") do
                  r.parse("ram:GuidelineSpecifiedDocumentContextParameter/ram:ID", :String) { inv.specification_id = it }
                end
                r.with_node("rsm:ExchangedDocument") do
                  r.parse("ram:ID", :String) { inv.invoice_number = it }
                  r.parse("ram:TypeCode", :String) { inv.invoice_type_code = it }
                  r.parse("ram:IssueDateTime", :Date) { inv.issue_date = it }
                  r.parse("ram:IncludedNote", :String) { inv.note = it }
                end

                # It seems common or normal in CII docs to omit the currency code for money attributes
                # which is fair enough considering the document specifies a currency code, but
                # we require a currency code for all `Money` types.
                # This gets set when parsing `InvoiceCurrencyCode`
                default_currency = nil

                r.with_node("rsm:SupplyChainTradeTransaction") do
                  r.with_node("ram:ApplicableHeaderTradeSettlement") do
                    r.parse("ram:PaymentReference", :String) { inv.purchase_order_number = it }
                    r.parse("ram:InvoiceCurrencyCode", :String) do
                      inv.currency_code = it
                      default_currency = inv.currency_code
                    end
                    r.parse_list("ram:SpecifiedTradeSettlementPaymentMeans", :PaymentMeans) { inv.payment_means = it }
                    r.with_node("ram:SpecifiedTradePaymentTerms") do
                      r.parse("ram:DueDateDateTime", :Date) { inv.due_date = it }
                    end
                    r.parse("ram:SpecifiedTradeSettlementHeaderMonetarySummation", :MonetaryTotal, default_currency:) do
                      inv.monetary_total = it
                    end
                    r.parse_list("ram:ApplicableTradeTax", :TaxSubtotal, default_currency:) do
                      inv.monetary_total.tax_breakdown.subtotals = it
                    end
                  end

                  r.with_node("ram:ApplicableHeaderTradeAgreement") do
                    r.parse("ram:SellerTradeParty", :TradeParty) { inv.supplier = it }
                    r.parse("ram:BuyerTradeParty", :TradeParty) { inv.buyer = it }
                  end

                  r.parse_list("ram:IncludedSupplyChainTradeLineItem", :InvoiceLine, default_currency:) do
                    inv.lines = it
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
