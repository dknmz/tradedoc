module Tradedoc
  module Model
    class BillingReference < Base
      has :type, Code::DocumentType
      has :document_reference, DocumentReference
    end
  end
end
