module Tradedoc
  module Format
    module CII
      module Coder
        class Contact
          def self.ruby_type
            Model::Contact
          end

          def self.dump(w, obj, as: "ram:DefinedTradeContact")
            w.add(as) do
              w.render(obj.name, as: "ram:PersonName")

              if (tel = obj.phone)
                w.add("ram:TelephoneUniversalCommunication") do
                  w.render(tel, as: "ram:CompleteNumber")
                end
              end

              if (email = obj.email)
                w.add("ram:EmailURIUniversalCommunication") do
                  w.render(email, as: "ram:URIID")
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |c|
              r.parse("ram:PersonName", :String) { c.name = it }
              r.with_node("ram:TelephoneUniversalCommunication") do
                r.parse("ram:CompleteNumber", :String) { c.phone = it }
              end
              r.with_node("ram:EmailURIUniversalCommunication") do
                r.parse("ram:URIID", :String) { c.email = it }
              end
            end
          end
        end
      end
    end
  end
end
