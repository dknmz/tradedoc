module Tradedoc
  module Code
    # Both CII and UBL share the same document type list and codes.
    # If other formats use different codes, they can be added here to avoid
    # gnarly and verbose mapping when generating and parsing documents.
    class DocumentType
      class << self
        def get(input)
          case input
          in String => cefact_id if cefact_id.match?(/^\d{3}/)
            @values.values.detect { it.cefact_id == cefact_id }
          in Symbol => id
            @values[id]
          in other
            "can't lookup by '#{other}'"
          end
        end

        def get!(input)
          if (v = get(input))
            return v
          end

          raise NotFoundError, "no document type could be found from '#{input}'"
        end

        def parse(input)
          get!(input)
        end

        def register(cefact_id, id, label: nil)
          @values ||= {}
          if @values.key?(id)
            raise ArgumentError, "id '#{id}' already registered"
          end

          @values[id] = new(id:, cefact_id:, label:)
        end
      end

      attr_reader :id, :cefact_id, :label

      # @param id [Symbol] Our own identifier for the document type
      # @param cefact_id [String]
      #   Numeric code from UN/CEFACT: https://vocabulary.uncefact.org/DocumentCodeList
      # @param label [String] Optional user-friendly label
      def initialize(id:, cefact_id:, label: nil)
        @id = id
        @cefact_id = cefact_id
        @label = label || id.to_s.tr("_", " ").capitalize
      end

      def to_h
        {id:, cefact_id:, label:}
      end

      # https://vocabulary.uncefact.org/DocumentCodeList
      register "326", :partial_invoice
      register "380", :commercial_invoice
      register "381", :credit_note
      register "383", :debit_note
      register "384", :corrected_invoice
      register "386", :prepayment_invoice
      register "389", :self_billed_invoice
      register "481", :remittance_advice
    end
  end
end
