module Tradedoc
  module Format
    module UBL
      module Coder
        class TradeParty
          def self.ruby_type
            Model::TradeParty
          end

          def self.dump(w, obj, as: "Party")
            w.add(as) do
              w.add("cac:PartyName") do
                w.add("cbc:Name", obj.name)
              end
              w.render(obj.address, as: "PostalAddress")
              w.render(obj.contact, as: "cac:Contact")
            end
          end

          def self.parse(r)
            obj = ruby_type.new

            r.with_node("cac:Party") do
              r.with_node("cac:PartyName") do
                r.parse("cbc:Name", :String) { obj.name = it }
              end
              r.parse("cac:PostalAddress", :Address) { obj.address = it }
              r.parse("cac:Contact", :Contact) { obj.contact = it }
            end

            obj
          end
        end
      end
    end
  end
end
