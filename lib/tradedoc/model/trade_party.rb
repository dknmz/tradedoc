module Tradedoc
  module Model
    class TradeParty < Base
      has :name, String
      has :address, Address
      has :contact, Contact
    end
  end
end
