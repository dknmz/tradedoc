module Tradedoc
  module Model
    class Address < Base
      has :city, String
      has :postal_code, String
      has :country, Country
      has :subdivision, CountrySubdivision

      # According to documentation and examples from UBL and CII, address lines
      # are used when you can't or don't want to break-down the parts of an address
      # to specific components like building number, suite/apartment number, PO Box,
      # attention of, care of, department code, etc. Free-form lines are easier to work with.
      has_many :lines, String

      # Optionally, the specific components of the address lines.
      has :street_name, String
      has :building_number, String
      has :additional_street_name, String
    end
  end
end
