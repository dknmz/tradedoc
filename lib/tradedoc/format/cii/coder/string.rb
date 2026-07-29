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
            v = r.text

            if strip
              v = v.strip
            end

            if nilify && v.empty?
              v = nil
            end

            v
          end
        end
      end
    end
  end
end
