module Tradedoc
  module Format
    module CII
      module Coder
        class String
          def self.ruby_type
            ::String
          end

          def self.dump(w, obj, as:)
            w.add(as, obj)
          end

          def self.parse(r, strip: true, nilify: true)
            r.text(strip:, nilify:)
          end
        end
      end
    end
  end
end
