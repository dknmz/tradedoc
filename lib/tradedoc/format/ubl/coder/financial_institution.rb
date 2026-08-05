module Tradedoc
  module Format
    module UBL
      module Coder
        class FinancialInstitution
          def self.ruby_type
            Model::FinancialInstitution
          end

          def self.dump(w, obj, as: "cac:FinancialInstitutionBranch")
            w.add(as) do
              w.add("cac:FinancialInstitution") do
                # If there's no NCS, then this is a SWIFT code
                scheme_name = if (ncs = obj.national_clearing_system)
                  ncs.iso_code
                else
                  "SWIFTBIC"
                end

                w.add("cbc:ID", obj.id, schemeName: scheme_name)
              end
            end
          end

          def self.parse(r)
            r.with_node("cac:FinancialInstitution") do
              ruby_type.new.tap do |obj|
                r.with_node("cbc:ID") do
                  obj.id = r.text

                  # Won't be present for SWIFT/BIC, and that's what we want
                  obj.national_clearing_system =
                    Tradedoc::Code::NationalClearingSystem.find_by_iso_code(r.attribute("schemeName"))
                end
              end
            end
          end
        end
      end
    end
  end
end
