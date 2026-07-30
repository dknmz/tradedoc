module Tradedoc
  module Format
    module UBL
      module Coder
        class Period
          def self.ruby_type
            Model::Period
          end

          def self.dump(w, obj, as:)
            w.add("cac:#{as}") do
              w.render(obj.start_date, as: "StartDate")
              w.render(obj.end_date, as: "EndDate")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("cbc:StartDate", :Date) { obj.start_date = it }
              r.parse("cbc:EndDate", :Date) { obj.end_date = it }
            end
          end
        end
      end
    end
  end
end
