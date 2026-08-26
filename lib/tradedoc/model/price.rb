module Tradedoc
  module Model
    # [BG-29]
    # The price of the invoiced item, including the net price, base quantity,
    # and any price discount from the gross price.
    class Price < Base
      # [BT-146] gross - discount
      has :net, Money

      # [BT-147] Discount applied to the gross to arrive at the net
      has :discount, Money

      # [BT-148] Price before any discounts
      has :gross, Money

      # [BT-149] The quantity to which the price applies
      #   (e.g. price per 100 units). Defaults to 1 if not specified.
      has :base_quantity, BigDecimal
    end
  end
end
