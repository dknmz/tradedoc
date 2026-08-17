module Tradedoc
  module Format
    module UBL
      module Coder
        class Invoice
          NS = {
            "xmlns:inv" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
            "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
            "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
          }.freeze

          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns:inv")
          end

          def self.ruby_type
            Model::Invoice
          end

          def self.dump(w, obj)
            w.add("inv:Invoice") do
              w.render(obj.invoice_number, as: "cbc:ID")
              w.render(obj.issue_date, as: "cbc:IssueDate")
              w.render(obj.due_date, as: "cbc:DueDate")
              w.add("cbc:InvoiceTypeCode", obj.invoice_type_code, listAgencyID: Code::Agency::CEFACT)
              w.render(obj.note, as: "cbc:Note")
              w.render(obj.currency_code, as: "cbc:DocumentCurrencyCode", listAgencyID: Code::Agency::CEFACT)
              w.render(obj.invoice_period)
              if (po_number = obj.purchase_order_number)
                w.add("cac:OrderReference") do
                  w.render(po_number, as: "cbc:ID")
                end
              end
              w.render(obj.supplier, as: "cac:AccountingSupplierParty")
              w.render(obj.buyer, as: "cac:AccountingCustomerParty")
              w.render(obj.monetary_total)
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |inv|
              r.with_node("inv:Invoice") do
                r.parse("cbc:ID", :String) { inv.invoice_number = it }
                r.parse("cbc:IssueDate", :Date) { inv.issue_date = it }
                r.parse("cbc:DueDate", :Date) { inv.due_date = it }
                r.parse("cbc:InvoiceTypeCode", :String) { inv.invoice_type_code = it }
                r.parse("cbc:Note", :String) { inv.note = it }
                r.parse("cbc:DocumentCurrencyCode", :String) { inv.currency_code = it }
                r.parse("cac:InvoicePeriod", :Period) { inv.invoice_period = it }
                r.parse("cac:AccountingSupplierParty", :TradeParty) { inv.supplier = it }
                r.parse("cac:AccountingCustomerParty", :TradeParty) { inv.buyer = it }
                r.parse("cac:LegalMonetaryTotal", :MonetaryTotal) { inv.monetary_total = it }

                r.with_node("cac:TaxTotal") do
                  inv.tax_breakdown = Model::TaxBreakdown.new.tap do |tax|
                    r.parse("cbc:TaxAmount", :Money) { tax.total_tax = it }
                    r.parse_list("cac:TaxSubtotal", :TaxSubtotal) { tax.subtotals = it }
                  end
                end

                r.with_nodes("cac:InvoiceLine") do
                  line = Model::InvoiceLine.new

                  r.parse("cbc:ID", :String) { line.id = it }
                  r.parse("cbc:InvoicedQuantity", :BigDecimal) { line.invoiced_quantity = it }
                  r.parse("cbc:LineExtensionAmount", :Money) { line.total_excluding_tax = it }

                  r.with_node("cac:Item") do
                    r.parse("cbc:Description", :String) { line.description = it }
                    r.parse("cbc:Name", :String) { line.name = it }
                  end

                  r.with_node("cac:Price") do
                    line.price = Model::Price.new.tap do |price|
                      r.parse("cbc:PriceAmount", :Money) { price.net = it }
                      r.parse("cbc:BaseQuantity", :BigDecimal) { price.base_quantity = it }
                    end
                  end

                  inv.lines.push(line)
                end

                r.with_node("cac:OrderReference") do
                  r.parse("cbc:ID", :String) { inv.purchase_order_number = it }
                end
              end
            end
          end
        end
      end
    end
  end
end
