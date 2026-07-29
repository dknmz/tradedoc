module Tradedoc
  module Format
    module UBL
      module Coder
        class FinancialAccount
          def self.ruby_type
            Model::FinancialAccount
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.add("cbc:ID", obj.account_number, schemeName: obj.scheme_name)
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.with_node("cbc:ID") do
                r.parse("@schemeName", :String) { obj.scheme_name = it }
                r.parse("text()", :String) { obj.account_number = it }
              end
            end
          end
        end
      end
    end
  end
end
