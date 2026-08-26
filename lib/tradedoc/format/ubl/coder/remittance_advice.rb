module Tradedoc
  module Format
    module UBL
      module Coder
        class RemittanceAdvice
          NS = {
            "xmlns:rad" => "urn:oasis:names:specification:ubl:schema:xsd:RemittanceAdvice-2",
            "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
            "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
          }.freeze

          private_constant :NS

          def self.namespaces
            NS
          end

          # @param xmldoc [Nokogiri::XML::Document]
          def self.can_parse?(xmldoc)
            xmldoc.root.namespace&.href == namespaces.fetch("xmlns:rad")
          end

          def self.ruby_type
            Model::RemittanceAdvice
          end

          def self.dump(w, obj)
            w.add("rad:RemittanceAdvice", NS) do
              w.add("cbc:ID", obj.id)
              w.render(obj.uuid, as: "cbc:UUID")
              w.render(obj.issue_date, as: "IssueDate")
              w.render(obj.note, as: "cbc:Note")

              w.render(obj.total_payment_amount, as: "TotalPaymentAmount")
              w.render(obj.invoice_period, as: "InvoicePeriod")

              w.add("cac:AccountingCustomerParty") do
                w.render(obj.buyer)
              end

              w.add("cac:AccountingSupplierParty") do
                w.render(obj.supplier)
              end

              w.render(obj.payment_means)

              obj.lines.each do |line|
                w.add("cac:RemittanceAdviceLine") do
                  w.add("cbc:ID", line.id)
                  w.render(line.note, as: "cbc:Note")
                  w.render(line.balance_amount, as: "BalanceAmount")
                  w.render(line.document_reference, as: "cac:BillingReference")
                  w.render(line.exchange_rate, as: "cac:ExchangeRate")
                end
              end
            end
          end

          def self.parse(r)
            obj = ruby_type.new

            r.with_node("rad:RemittanceAdvice") do
              r.parse("cbc:ID", :String) { obj.id = it }
              r.parse("cbc:UUID", :String) { obj.uuid = it }
              r.parse("cbc:IssueDate", :Date) { obj.issue_date = it }
              r.parse("cbc:Note", :String) { obj.note = it }
              r.parse("cbc:TotalPaymentAmount", :Money) { obj.total_payment_amount = it }
              r.parse("cac:AccountingCustomerParty", :TradeParty) { obj.buyer = it }
              r.parse("cac:AccountingSupplierParty", :TradeParty) { obj.supplier = it }
              r.parse("cac:PaymentMeans", :PaymentMeans) { obj.payment_means = it }
              r.parse("cac:InvoicePeriod", :Period) { obj.invoice_period = it }

              r.with_nodes("cac:RemittanceAdviceLine") do
                line = Model::RemittanceAdviceLine.new
                r.parse("cbc:ID", :String) { line.id = it }
                r.parse("cbc:Note", :String) { line.note = it }
                r.parse("cbc:BalanceAmount", :Money) { line.balance_amount = it }
                r.parse("cac:BillingReference", :DocumentReference) { line.document_reference = it }
                r.parse("cac:ExchangeRate", :ExchangeRate) { line.exchange_rate = it }

                obj.lines.push(line)
              end
            end

            obj
          end
        end
      end
    end
  end
end
