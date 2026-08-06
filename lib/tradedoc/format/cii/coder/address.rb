module Tradedoc
  module Format
    module CII
      module Coder
        class Address
          # Address lines are limited to 5, and each node gets its own name including
          # the number in English.
          LINE_WORDS = ["One", "Two", "Three", "Four", "Five"]
          private_constant :LINE_WORDS

          def self.ruby_type
            Model::Address
          end

          def self.dump(w, obj, as:)
            w.add(as) do
              w.render(obj.postal_code, as: "PostcodeCode")
              obj.lines.each_with_index do |line, ix|
                w.add("Line#{LINE_WORDS[ix]}", line)
              end
              w.render(obj.street_name, as: "StreetName")
              w.render(obj.city, as: "CityName")
              w.render(obj.country.iso_code, as: "CountryID")
              w.render(obj.country.name, as: "CountryName")
              w.render(obj.subdivision&.code, as: "CountrySubDivisionID")
              w.render(obj.subdivision&.name, as: "CountrySubDivisionName")
              w.render(obj.building_number, as: "BuildingNumber")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |obj|
              obj.subdivision = {}
              r.parse("ram:PostcodeCode", :String) { obj.postal_code = it }
              r.parse("ram:StreetName", :String) { obj.street_name = it }
              r.parse("ram:CityName", :String) { obj.city = it }
              r.parse("ram:CountrySubDivisionName", :String) { obj.subdivision.name = it }
              r.parse("ram:CountrySubDivisionID", :String) { obj.subdivision.code = it }
              r.parse("ram:BuildingNumber", :String) { obj.building_number = it }

              obj.country = Model::Country.new.tap do |c|
                r.parse("ram:CountryID", :String) { c.iso_code = it }
                r.parse("ram:CountryName", :String) { c.name = it }
              end

              LINE_WORDS.each do |word|
                r.with_node("ram:Line#{word}") { obj.lines.push(r.text) }
              end
            end
          end
        end
      end
    end
  end
end
