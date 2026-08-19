module Tradedoc
  module Model
    # [BG-31]
    # Known in UBL as an `Item`, this is any product or item that can be traded.
    # Includes things like the description, colour, product code, catalogue code, weights, etc.
    class Product < Base
      # [BT-153] Required
      has :name, String

      # [BT-154]
      has :description, String

      has :seller_assigned_id, String

      has :tax_category, TaxCategory
    end
  end
end
