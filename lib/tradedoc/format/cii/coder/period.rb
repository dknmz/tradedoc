module Tradedoc
  module Format
    module CII
      module Coder
        class Period
          def self.ruby_type
            Model::Period
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.starts_at, as: "ram:StartDateTime")
              w.render(obj.ends_at, as: "ram:EndDateTime")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("ram:StartDateTime", :Time) { obj.starts_at = it }
              r.parse("ram:EndDateTime", :Time) { obj.ends_at = it }
            end
          end
        end
      end
    end
  end
end
