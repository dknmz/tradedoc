module Tradedoc
  module Model
    class Address < Base
      has :street_name, String
      has :building_number, String
      has :additional_street_name, String
      has :city, String
      has :postal_code, String
      has :country, Country
      has :subdivision, CountrySubdivision
    end
  end
end
