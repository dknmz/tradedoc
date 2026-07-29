module Tradedoc
  module Model
    class DocumentReference < Base
      has :id, String
      has :uuid, String
      has :issued_at, Time
      has :note, String
    end
  end
end
