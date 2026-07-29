module Tradedoc
  module Format
    module CII
      module Coder
        class RemittanceAdvice
          NS = {
            "xmlns:qdt" => "urn:un:unece:uncefact:data:standard:QualifiedDataType:100",
            "xmlns:ram" => "urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100",
            "xmlns:rsm" => "urn:un:unece:uncefact:data:standard:CrossIndustryRemittanceAdvice:100",
            "xmlns:udt" => "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100",
            "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema"
          }.freeze

          def self.namespaces
            NS
          end

          def self.can_parse?(xmldoc)
            xmldoc.root.namespace.href == namespaces.fetch("xmlns:rsm")
          end

          def self.ruby_type
            Model::RemittanceAdvice
          end

          def self.dump(w, obj)
            w.add("rsm:CrossIndustryRemittanceAdvice", NS) do
              w.add("ExchangedDocument") do
                w.add("ram:ID", obj.id)
                w.render(obj.issued_at, as: "ram:IssueDateTime")

                if (note = obj.note)
                  w.add("ram:IncludedNote") do
                    w.add("ram:Content", note)
                  end
                end

                w.render(obj.invoice_period, as: "ram:EffectiveSpecifiedPeriod")
              end

              w.add("rsm:TradeSettlementPayment") do
                w.render(obj.payment_means.payment_id, as: "ram:EndToEndID")
                w.render(obj.payment_means.instruction_id, as: "ram:InstructionID")
                w.add("ram:SpecifiedPaymentTradeSettlement") do
                  w.render(obj.supplier, as: "PayeeTradeParty")
                  w.render(obj.buyer, as: "PayerTradeParty")
                  w.add("ram:SpecifiedTradeSettlementPaymentMonetarySummation") do
                    w.render(obj.total_payment_amount, as: "PaymentTotalAmount")
                  end
                  w.render(obj.payment_means)
                end
              end

              obj.lines.each do |line|
                w.add("rsm:SupplyChainTradeTransaction") do
                  w.render(line.billing_reference)

                  w.add("ram:AssociatedDocumentLineDocument") do
                    w.add("ram:LineID", line.id)
                  end

                  w.add("ram:ApplicableHeaderTradeSettlement") do
                    w.add("ram:SpecifiedTradeSettlementHeaderMonetarySummation") do
                      w.render(line.balance_amount, as: "PaymentTotalAmount")
                    end
                  end
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |ra|
              r.with_node("rsm:CrossIndustryRemittanceAdvice") do
                r.with_node("rsm:ExchangedDocument") do
                  r.parse("ram:ID", :String) { ra.id = it }
                  r.with_node("ram:IncludedNote") do
                    r.parse("ram:Content", :String) { ra.note = it }
                  end
                  r.parse("ram:IssueDateTime", :Time) { ra.issued_at = it }
                  r.parse("ram:EffectiveSpecifiedPeriod", :Period) { ra.invoice_period = it }
                end

                r.with_node("rsm:TradeSettlementPayment") do
                  r.with_node("ram:SpecifiedPaymentTradeSettlement") do
                    r.parse("ram:PayeeTradeParty", :TradeParty) { ra.supplier = it }
                    r.parse("ram:PayerTradeParty", :TradeParty) { ra.buyer = it }
                    r.parse("ram:SpecifiedTradeSettlementPaymentMeans", :PaymentMeans) { ra.payment_means = it }

                    r.with_node("ram:SpecifiedTradeSettlementPaymentMonetarySummation") do
                      r.parse("ram:PaymentTotalAmount", :Money) { ra.total_payment_amount = it }
                    end
                  end

                  # Our `PaymentMeans` is spread across multiple different nodes, so we can't
                  # do a nice clean parse all at once. We have to add to the existing object.
                  r.parse("ram:EndToEndID", :String) { ra.payment_means.payment_id = it }
                  r.parse("ram:InstructionID", :String) { ra.payment_means.instruction_id = it }
                end

                r.with_nodes("rsm:SupplyChainTradeTransaction") do
                  line = Model::RemittanceAdviceLine.new

                  r.parse("ram:AssociatedReferencedDocument", BillingReference) { line.billing_reference = it }
                  r.with_node("ram:AssociatedDocumentLineDocument") do
                    r.parse("ram:LineID", :String) { line.id = it }
                  end

                  r.with_node("ram:ApplicableHeaderTradeSettlement") do
                    r.with_node("ram:SpecifiedTradeSettlementHeaderMonetarySummation") do
                      r.parse("ram:GrandTotalAmount", :Money) { line.debit_amount = it }
                      r.parse("ram:TotalDiscountBasis", :Money) { line.credit_amount = it }
                      r.parse("ram:PaymentTotalAmount", :Money) { line.balance_amount = it }
                    end
                  end

                  ra.lines.push(line)
                end
              end
            end
          end
        end
      end
    end
  end
end
