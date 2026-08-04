module Tradedoc
  module Format
    module UBL
      module Coder
        class BigDecimal
          def self.ruby_type
            ::BigDecimal
          end

          def self.dump(w, obj, as:, round: 2)
            formatted = obj.round(round).to_s("F")
            w.add(as, formatted)
          end

          def self.parse(r)
            ruby_type.interpret_loosely(r.text)
          end
        end
      end
    end
  end
end
