module Tradedoc
  module Format
    module UBL
      module Coder
        class Contact
          def self.ruby_type
            Model::Contact
          end

          def self.dump(w, obj, as: "cac:Contact")
            w.add(as) do
              w.render(obj.name, as: "cbc:Name")
              w.render(obj.phone, as: "cbc:Telephone")
              w.render(obj.email, as: "cbc:ElectronicMail")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |c|
              r.parse("cbc:Name", :String) { c.name = it }
              r.parse("cbc:Telephone", :String) { c.phone = it }
              r.parse("cbc:ElectronicMail", :String) { c.email = it }
            end
          end
        end
      end
    end
  end
end
