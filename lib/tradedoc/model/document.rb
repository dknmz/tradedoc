module Tradedoc
  module Model
    class Document < Base
      has :id, String
      has :issue_date, Date
      has :note, String
    end
  end
end
