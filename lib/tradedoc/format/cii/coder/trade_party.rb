module Tradedoc
  module Format
    module CII
      module Coder
        class TradeParty
          def self.ruby_type
            Model::TradeParty
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.name, as: "Name")
              w.render(obj.contact, as: "ram:DefinedTradeContact")
              w.render(obj.address, as: "PostalTradeAddress")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |tp|
              r.parse("ram:Name", :String) { tp.name = it }
              r.parse("ram:DefinedTradeContact", :Contact) { tp.contact = it }
              r.parse("ram:PostalTradeAddress", :Address) { tp.address = it }
            end
          end
        end
      end
    end
  end
end
