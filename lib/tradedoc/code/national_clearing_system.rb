module Tradedoc
  module Code
    # Most bank accounts aside from IBAN will have two components: account number + clearing ID
    # For example in the US, the clearing ID is the routing number.
    #
    # For CII/CEFACT, each type gets mapped to an XML element name. Though this is technically
    # "not the right" place for this, it's less bad than defining a list and then a mapping separately.
    #
    # This list comes from ISO-20022 `ExternalClearingSystemIdentificationCode`
    class NationalClearingSystem
      attr_reader :iso_code, :cefact_id, :label

      def initialize(iso_code:, cefact_id:, label: nil)
        @iso_code = iso_code
        @cefact_id = cefact_id
        @label = label || cefact_id.sub(/ID$/, "")
      end

      def to_h
        {iso_code:, cefact_id:, label:}
      end

      def deconstruct_keys(keys)
        to_h
      end

      def hash
        to_h.hash
      end

      def ==(other)
        case other
        in NationalClearingSystem => t
          t.hash == hash
        in String | Symbol => pattern
          self == self.class.get(pattern)
        in Hash => h
          to_h == h
        in _
          false
        end
      end

      def eql?(other)
        self == other
      end

      class << self
        def all
          @values.values
        end

        def find_by_iso_code(input)
          @values[input]
        end

        def find_by_cefact_id(cefact_id)
          @values.detect { it.cefact_id == cefact_id }
        end

        def parse(input)
          if (v = find_by_iso_code(input))
            return v
          end

          raise "couldn't parse '#{input}' to a clearing code"
        end

        private

        def register(iso_code, cefact_id, label: nil)
          @values ||= {}
          if @values.key?(iso_code)
            raise ArgumentError, "'#{iso_code}' already registered"
          end

          @values[iso_code] = new(iso_code:, cefact_id:, label:).freeze
        end

        def lock_registry!
          @values.freeze
        end
      end

      register "AUBSB", "AustralianBSBID"
      register "CACPA", "CanadianPaymentsAssociationID"
      register "GBDSC", "UKSortCodeID"
      register "HKNCC", "HongKongBankID"
      register "NZRSA", "NewZealandNCCID"
      register "USABA", "FedwireRoutingNumberID"
      register "USPID", "CHIPSUniversalID"
      register "ZANCC", "SouthAfricanNCCID"

      lock_registry!
    end
  end
end
