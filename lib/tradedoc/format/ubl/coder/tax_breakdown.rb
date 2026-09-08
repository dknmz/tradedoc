module Tradedoc
  module Format
    module UBL
      module Coder
        class TaxBreakdown
          def self.ruby_type
            Model::TaxBreakdown
          end

          def self.dump(w, obj, as: "cac:TaxTotal")
            w.add(as) do
              w.render(obj.total_tax, as: "TaxAmount")
              w.render_list(obj.subtotals, as: "cac:TaxSubtotal")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |tax|
              r.parse("cbc:TaxAmount", :Money) { tax.total_tax = it }
              r.parse_list("cac:TaxSubtotal", :TaxSubtotal) { tax.subtotals = it }
            end
          end
        end
      end
    end
  end
end
