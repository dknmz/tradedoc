# CII, or Cross-Industry Invoice standard from UN/CEFACT
module Tradedoc
  module Format
    module CII
      extend Accessors
      extend Finders
      extend XMLSerialization
    end
  end
end

require_relative "cii/coder"
