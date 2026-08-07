module Tradedoc
  module Format
    module UBL
      module Coder
        class PaymentMeans
          def self.ruby_type
            Model::PaymentMeans
          end

          def self.dump(w, obj, as: "cac:PaymentMeans")
            w.add(as) do
              w.add("cbc:PaymentMeansCode", obj.type_code.code, listID: "UN/CE 4461", listAgencyID: Code::Agency::CEFACT)
              w.render(obj.instruction_id, as: "cbc:InstructionID")
              obj.messages.each do |msg|
                w.add("cbc:InstructionNote", msg)
              end
              w.render(obj.payment_id, as: "cbc:PaymentID")
              w.render(obj.sending_account, as: "cac:PayerFinancialAccount")
              w.render(obj.receiving_account, as: "cac:PayeeFinancialAccount")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("cbc:PaymentMeansCode", :String) { obj.type_code = it }
              r.parse("cbc:PaymentID", :String) { obj.payment_id = it }
              r.parse("cbc:InstructionID", :String) { obj.instruction_id = it }
              r.with_nodes("cbc:InstructionNote") do
                obj.messages.push(r.text)
              end
              r.parse("cac:PayerFinancialAccount", :FinancialAccount) { obj.sending_account = it }
              r.parse("cac:PayeeFinancialAccount", :FinancialAccount) { obj.receiving_account = it }
            end
          end
        end
      end
    end
  end
end
