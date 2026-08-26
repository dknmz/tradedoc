module Tradedoc
  module Code
    # UN/EDIFACT 5305 Duty or tax or fee category code
    # https://unece.org/fileadmin/DAM/trade/untdid/d16b/tred/tred5305.htm
    class TaxCategory
      class << self
        def get(input)
          case input
          in String => edifact_id if edifact_id.match?(/^[A-Z]{1,2}$/)
            @values.values.detect { it.edifact_id == edifact_id }
          in Symbol => id
            @values[id]
          in other
            raise "can't lookup by '#{other.class}'"
          end
        end

        def get!(input)
          if (v = get(input))
            return v
          end

          raise NotFoundError, "no tax category could be found from '#{input}'"
        end

        def parse(input)
          get!(input)
        end

        private

        def register(edifact_id, id)
          @values ||= {}
          @values[id] = new(id:, edifact_id:)
        end
      end

      attr_reader :id, :edifact_id

      def initialize(id:, edifact_id:)
        @id = id
        @edifact_id = edifact_id
      end

      def to_h
        {id:, edifact_id:}
      end

      def deconstruct_keys(keys)
        to_h
      end

      def hash
        to_h.hash
      end

      def ==(other)
        case other
        in TaxCategory => tc
          tc.hash == hash
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

      register "A", :mixed_rate
      register "AA", :lower_rate
      register "AB", :exempt_for_resale
      register "AC", :not_due_now
      register "AD", :due_from_previous
      register "AE", :reverse_charge
      register "B", :transferred
      register "C", :duty_paid_by_supplier
      register "D", :travel_agent
      register "E", :exempt
      register "F", :second_hand_goods
      register "G", :free_export
      register "H", :higher_rate
      register "I", :works_of_art
      register "J", :collectables_and_antiques
      register "K", :eea_intra_community_exempt
      register "L", :canary_islands_general_indirect
      register "M", :ceuta_melilla
      register "O", :services_outside_scope
      register "S", :standard
      register "Z", :zero_rated
    end
  end
end
