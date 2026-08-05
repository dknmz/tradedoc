module Tradedoc
  module Format
    module CII
      module Coder
        class FinancialAccount
          # When an account is IBAN, it gets a node called IBANID with the account number as the text.
          # For any other account type, the node is ProprietaryID.
          IBAN_SCHEME = "IBAN"
          EL_IBAN = "ram:IBANID"
          EL_PROPRIETARY = "ram:ProprietaryID"

          private_constant :IBAN_SCHEME, :EL_IBAN, :EL_PROPRIETARY

          def self.ruby_type
            Model::FinancialAccount
          end

          def self.dump(w, obj, as:)
            w.add("ram:#{as}") do
              case obj.scheme_name
              in IBAN_SCHEME
                w.add(EL_IBAN, obj.account_number)
              in other
                w.add(EL_PROPRIETARY, obj.account_number, schemeName: other)
              end
            end
          end

          def self.parse(r)
            # only one of these nodes will be present

            r.with_node(EL_IBAN) do
              return ruby_type.new(scheme_name: IBAN_SCHEME, account_number: r.text)
            end

            r.with_node(EL_PROPRIETARY) do
              scheme_name = r.attribute("schemeName")
              return ruby_type.new(scheme_name:, account_number: r.text)
            end
          end
        end
      end
    end
  end
end
