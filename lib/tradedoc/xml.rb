module Tradedoc
  module XML
    Error = Class.new(Tradedoc::Error)
    NoCoderError = Class.new(Error)
  end
end

require_relative "xml/reader"
require_relative "xml/writer"
