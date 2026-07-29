module Tradedoc
  module Format
    module UBL
      module Coder
        class Country
          def self.ruby_type
            Model::Country
          end

          def self.dump(w, obj, as: "cac:Country")
            w.add(as) do
              w.render(obj.iso_code, as: "cbc:IdentificationCode")
              w.render(obj.name, as: "cbc:Name")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |c|
              r.parse("cbc:IdentificationCode", :String) { c.iso_code = it }
              r.parse("cbc:Name", :String) { c.name = it }
            end
          end
        end
      end
    end
  end
end
