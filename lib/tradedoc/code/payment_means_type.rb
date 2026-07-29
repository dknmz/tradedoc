module Tradedoc
  module Code
    class PaymentMeansType
      class << self
        def get(input)
          case input
          in String => code if code.match?(/^\d+$/)
            @values.values.detect { it.code == code }
          in Symbol => id
            @values[id]
          in other
            raise "can't lookup by '#{other}'"
          end
        end

        def get!(input)
          if (v = get(input))
            return v
          end

          raise NotFoundError, "no payment means type could be found from '#{input}'"
        end

        def parse(input)
          get!(input)
        end

        def register(code, id, label: nil)
          @values ||= {}
          if @values.key?(id)
            raise ArgumentError, "id '#{id}' already registered"
          end

          @values[id] = new(id:, code:, label:)
        end
      end

      attr_reader :id, :code, :label

      # @param id [Symbol] Our own internal identifier
      # @param code [String]
      #   UN/ECE 4461: https://unece.org/fileadmin/DAM/trade/untdid/d16b/tred/tred4461.htm
      # @param label [String] Optional user-friendly label.
      def initialize(id:, code:, label: nil)
        @id = id
        @code = code
        @label = label || id.to_s.tr("_", " ").capitalize
      end

      register "1", :instrument_not_defined
      register "2", :ach_credit, label: "ACH credit"
      register "3", :ach_debit, label: "ACH debit"
      register "10", :cash
      register "20", :cheque
      register "30", :credit_transfer
      register "31", :debit_transfer
      register "54", :credit_card
      register "58", :sepa_credit_transfer, label: "SEPA credit transfer"
      register "59", :sepa_direct_debit, label: "SEPA direct debit"
    end
  end
end
