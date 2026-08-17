module Tradedoc
  module Format
    # ZUGFeRDv1 is a German standard that is the predecessor of CII and its
    # data structures are quite similar and sometimes identical.
    #
    # Not officially obsolete (as of June 2026) but its website says:
    #     ...has never been officially deprecated but is likely to be discontinued
    #     and it's not compliant to EN16931
    module ZugferdV1
      extend Accessors
      extend Finders
      extend XMLSerialization

      def self.label
        "ZUGFeRDv1"
      end
    end
  end
end

require_relative "zugferdv1/coder"
