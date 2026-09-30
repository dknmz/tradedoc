module Tradedoc
  module Model
    # [BG-4]
    class TradeParty < Base
      has :name, String
      has :address, Address
      has :contact, Contact

      # [BT-63]
      has :vat_id, String
    end
  end
end
