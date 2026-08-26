module Tradedoc
  module Format
    module UBL
      module Coder
        class String
          def self.ruby_type
            ::String
          end

          def self.dump(w, obj, as:, **opts)
            w.add(as, obj, **opts)
          end

          def self.parse(r, strip: true, nilify: true)
            r.text(strip:, nilify:)
          end
        end
      end
    end
  end
end
