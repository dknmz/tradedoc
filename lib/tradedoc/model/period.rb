module Tradedoc
  module Model
    class Period < Base
      has :starts_at, Time
      has :ends_at, Time
    end
  end
end
