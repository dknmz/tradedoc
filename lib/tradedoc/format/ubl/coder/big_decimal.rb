module Tradedoc
  module Format
    module UBL
      module Coder
        class BigDecimal
          def self.ruby_type
            ::BigDecimal
          end

          def self.dump(w, obj, as:)
            w.add(as, obj.to_s("F"))
          end

          def self.parse(r)
            ruby_type.interpret_loosely(r.text)
          end
        end
      end
    end
  end
end
