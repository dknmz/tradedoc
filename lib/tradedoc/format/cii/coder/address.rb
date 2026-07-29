module Tradedoc
  module Format
    module CII
      module Coder
        class Address
          def self.ruby_type
            Model::Address
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.postal_code, as: "PostcodeCode")
              w.render(obj.street_name, as: "StreetName")
              w.render(obj.city, as: "CityName")
              w.render(obj.country.iso_code, as: "CountryID")
              w.render(obj.country.name, as: "CountryName")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              r.parse("ram:PostcodeCode", :String) { obj.postal_code = it }
              r.parse("ram:StreetName", :String) { obj.street_name = it }
              r.parse("ram:CityName", :String) { obj.city = it }

              obj.country = Model::Country.new.tap do |c|
                r.parse("ram:CountryID", :String) { c.iso_code = it }
                r.parse("ram:CountryName", :String) { c.name = it }
              end
            end
          end
        end
      end
    end
  end
end
