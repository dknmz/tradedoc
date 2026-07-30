module Tradedoc
  module Model
    class Period < Base
      has :start_date, Date
      has :end_date, Date
    end
  end
end
