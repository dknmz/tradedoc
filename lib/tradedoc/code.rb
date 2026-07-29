module Tradedoc
  module Code
    Error = Class.new(Tradedoc::Error)
    NotFoundError = Class.new(Error)
  end
end

require_relative "code/agency"
require_relative "code/document_type"
require_relative "code/payment_means_type"
