module Tradedoc
  module Format
    module UBL
      module Coder
        class Address
          def self.ruby_type
            Model::Address
          end

          def self.dump(w, obj, as:)
            w.add("cac:#{as}") do
              w.render(obj.street_name, as: "cbc:StreetName")
              w.render(obj.building_number, as: "cbc:BuildingNumber")
              w.render(obj.city, as: "cbc:CityName")
              w.render(obj.postal_code, as: "cbc:PostalZone")
              w.render(obj.subdivision&.name, as: "cbc:CountrySubentity")
              w.render(obj.subdivision&.code, as: "cbc:CountrySubentityCode")
              obj.lines.each do |line|
                w.add("cac:AddressLine") do
                  w.add("cbc:Line", line)
                end
              end
              w.render(obj.country)
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              obj.subdivision = {}
              r.parse("cbc:StreetName", :String) { obj.street_name = it }
              r.parse("cbc:BuildingNumber", :String) { obj.building_number = it }
              r.parse("cbc:CityName", :String) { obj.city = it }
              r.parse("cbc:PostalZone", :String) { obj.postal_code = it }
              r.parse("cbc:CountrySubentity", :String) { obj.subdivision.name = it }
              r.parse("cbc:CountrySubentityCode", :String) { obj.subdivision.code = it }
              r.parse("cac:Country", :Country) { obj.country = it }
              r.with_nodes("cac:AddressLine") do
                r.with_node("cbc:Line") do
                  obj.lines.push(r.text)
                end
              end
            end
          end
        end
      end
    end
  end
end
