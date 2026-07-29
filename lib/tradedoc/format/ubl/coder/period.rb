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
              w.render(obj.starts_at&.to_date, as: "StartDate")
              w.render(obj.ends_at&.to_date, as: "EndDate")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("cbc:StartDate", :Date) { obj.starts_at = it.to_time }
              r.parse("cbc:EndDate", :Date) { obj.ends_at = it.to_time }
            end
          end
        end
      end
    end
  end
end
