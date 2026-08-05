module Tradedoc
  module Format
    module CII
      module Coder
        class PaymentMeans
          def self.ruby_type
            Model::PaymentMeans
          end

          def self.dump(w, obj)
            w.add("ram:SpecifiedTradeSettlementPaymentMeans") do
              w.add("ram:TypeCode", obj.type_code.code, listAgencyID: Code::Agency::CEFACT)

              w.render(obj.sending_account, as: "PayerPartyDebtorFinancialAccount")
              w.render(obj.receiving_account, as: "PayeePartyCreditorFinancialAccount")

              w.render(obj.sending_account.financial_institution, as: "PayerSpecifiedDebtorFinancialInstitution")
              w.render(obj.receiving_account.financial_institution, as: "PayeeSpecifiedCreditorFinancialInstitution")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |pm|
              r.parse("ram:TypeCode", :String) { pm.type_code = it }

              r.parse("ram:PayerPartyDebtorFinancialAccount", :FinancialAccount) { pm.sending_account = it }
              r.parse("ram:PayerSpecifiedDebtorFinancialInstitution", :FinancialInstitution) do
                pm.sending_account.financial_institution = it
              end

              r.parse("ram:PayeePartyCreditorFinancialAccount", :FinancialAccount) { pm.receiving_account = it }
              r.parse("ram:PayeeSpecifiedCreditorFinancialInstitution", :FinancialInstitution) do
                pm.receiving_account.financial_institution = it
              end
            end
          end
        end
      end
    end
  end
end
