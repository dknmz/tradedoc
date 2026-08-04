module Tradedoc
  module Model
    class DocumentReference < Base
      has :type, Code::DocumentType
      has :id, String
      has :uuid, String
      has :issue_date, Date
      has :note, String
    end
  end
end
