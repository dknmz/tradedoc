module Tradedoc
  module Format
    module CII
      module Coder
        class FinancialInstitution
          def self.ruby_type
            Model::FinancialInstitution
          end

          # This one is a little unusual.
          def self.dump(w, obj, as:)
            w.add(as) do
              # BIC is *not* a national clearing system.
              # If no clearing system is defined, then this is BIC.
              if (ncs = obj.national_clearing_system)
                w.add("ram:#{ncs.cefact_id}", obj.id)
              else
                w.add("ram:BICID", obj.id)
              end
            end
          end

          def self.parse(r)
            r.with_node("ram:BICID") do
              return ruby_type.new(id: r.text)
            end

            # Now we have to figure out the national clearing system by node name
            Tradedoc::Code::NationalClearingSystem.all.each do |ncs|
              r.with_node("ram:#{ncs.cefact_id}") do
                return ruby_type.new(id: r.text, national_clearing_system: ncs)
              end
            end
          end
        end
      end
    end
  end
end
