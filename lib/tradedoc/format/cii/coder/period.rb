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
              w.render(obj.start_date, as: "ram:StartDateTime")
              w.render(obj.end_date, as: "ram:EndDateTime")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("ram:StartDateTime", :Date) { obj.start_date = it }
              r.parse("ram:EndDateTime", :Date) { obj.end_date = it }
            end
          end
        end
      end
    end
  end
end
