module Tradedoc
  module Format
    # Poland
    # https://ksef.mf.gov.pl/
    module KSEF
      extend Accessors
      extend Finders
      extend XMLSerialization

      def self.label
        "KSeF"
      end
    end
  end
end

require_relative "ksef/coder"
