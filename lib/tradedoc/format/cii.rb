# CII, or Cross-Industry Invoice standard from UN/CEFACT
module Tradedoc
  module Format
    module CII
      # https://unece.org/fileadmin/DAM/trade/edifact/code/3055cl.htm
      AGENCY_ID = "6"
    end
  end
end

require_relative "cii/coder"
require_relative "cii/document"
