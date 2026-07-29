module Tradedoc
  module Model
    class Document < Base
      has :id, String
      has :issued_at, Time
      has :note, String
    end
  end
end
