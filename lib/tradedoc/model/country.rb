module Tradedoc
  module Model
    class Country < Base
      has :iso_code, String
      has :name, String
    end
  end
end
