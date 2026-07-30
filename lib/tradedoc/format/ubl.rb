module Tradedoc
  module Format
    # Universal Business Language
    # A open set of standards designed by OASIS
    module UBL
      extend Accessors
      extend Finders
      extend XMLSerialization
    end
  end
end

require_relative "ubl/coder"
