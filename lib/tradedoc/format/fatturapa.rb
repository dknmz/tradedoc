module Tradedoc
  module Format
    # Italian e-invoice format. Not compliant with EN 16931.
    # https://www.fatturapa.gov.it/en/norme-e-regole/documentazione-fattura-elettronica/formato-fatturapa/
    module FatturaPA
      extend Accessors
      extend Finders
      extend XMLSerialization
    end
  end
end

require_relative "fatturapa/coder"
