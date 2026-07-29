module Tradedoc
  module Format
    module UBL
      module Coder
        class Date
          def self.ruby_type
            ::Date
          end

          def self.dump(w, obj, as:)
            w.add("cbc:#{as}", obj.to_date.iso8601)
          end

          def self.parse(r)
            ruby_type.parse(r.text)
          end
        end
      end
    end
  end
end
