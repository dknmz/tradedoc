module Tradedoc
  module Format
    module UBL
      module Coder
        class Invoice
          NS = {
            "xmlns:inv" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
            "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
            "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
            "xmlns:ext" => "urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
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
            w.add("inv:Invoice", NS) do
              w.render(obj.specification_id, as: "cbc:CustomizationID")
              w.render(obj.invoice_number, as: "cbc:ID")
              w.render(obj.issue_date, as: "IssueDate")
              w.render(obj.due_date, as: "cbc:DueDate")
              w.render(obj.invoice_type_code, as: "cbc:InvoiceTypeCode", listAgencyID: Code::Agency::CEFACT)
              w.render(obj.note, as: "cbc:Note")
              w.render(obj.currency_code, as: "cbc:DocumentCurrencyCode", listAgencyID: Code::Agency::CEFACT)
              w.render(obj.invoice_period, as: "InvoicePeriod")
              if (po_number = obj.purchase_order_number)
                w.add("cac:OrderReference") do
                  w.render(po_number, as: "cbc:ID")
                end
              end
              if (supplier = obj.supplier)
                w.add("cac:AccountingSupplierParty") do
                  w.render(supplier, as: "cac:Party")
                end
              end
              if (buyer = obj.buyer)
                w.add("cac:AccountingCustomerParty") do
                  w.render(buyer, as: "cac:Party")
                end
              end
              w.render(obj.monetary_total.tax_breakdown)
              w.render(obj.monetary_total)
              w.render_list(obj.lines)
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
                r.parse("cac:AccountingSupplierParty/cac:Party", :TradeParty) { inv.supplier = it }
                r.parse("cac:AccountingCustomerParty/cac:Party", :TradeParty) { inv.buyer = it }
                r.parse("cac:LegalMonetaryTotal", :MonetaryTotal) { inv.monetary_total = it }
                r.parse("cac:TaxTotal", :TaxBreakdown) { inv.monetary_total.tax_breakdown = it }
                r.parse_list("cac:InvoiceLine", :InvoiceLine) { inv.lines = it }

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
