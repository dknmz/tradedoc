module Tradedoc
  module Format
    module CII
      module Coder
        class TradeParty
          VAT_TYPE = "VA"
          private_constant :VAT_TYPE

          def self.ruby_type
            Model::TradeParty
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.name, as: "Name")
              w.render(obj.contact, as: "ram:DefinedTradeContact")
              w.render(obj.address, as: "PostalTradeAddress")
              w.render(obj.vat_id) do |vat_id|
                w.add("ram:SpecifiedTaxRegistration") do
                  w.add("ram:ID", vat_id, schemeID: VAT_TYPE)
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |tp|
              r.parse("ram:Name", :String) { tp.name = it }
              r.parse("ram:DefinedTradeContact", :Contact) { tp.contact = it }
              r.parse("ram:PostalTradeAddress", :Address) { tp.address = it }
              r.parse("ram:SpecifiedTaxRegistration/ram:ID[@schemeID='#{VAT_TYPE}']", :String) do
                tp.vat_id = it
              end
            end
          end
        end
      end
    end
  end
end
