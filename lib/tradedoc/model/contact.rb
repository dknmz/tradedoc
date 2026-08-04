module Tradedoc
  module Model
    class Contact < Base
      has :name, String
      has :phone, String
      has :email, String
    end
  end
end
