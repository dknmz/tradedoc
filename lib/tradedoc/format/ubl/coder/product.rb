module Tradedoc
  module Format
    module UBL
      module Coder
        class Product
          def self.ruby_type
            Model::Product
          end

          def self.dump(w, obj, as: "cac:Item")
            w.add(as) do
              w.render(obj.description, as: "cbc:Description")
              w.render(obj.name, as: "cbc:Name")
              if (id = obj.seller_assigned_id)
                w.add("cac:SellersItemIdentification") do
                  w.render(id, as: "cbc:ID")
                end
              end
              w.render(obj.tax_category, as: "cac:ClassifiedTaxCategory")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |prod|
              r.parse("cbc:Description", :String) { prod.description = it }
              r.parse("cbc:Name", :String) { prod.name = it }
              r.with_node("cac:SellersItemIdentification") do
                r.parse("cbc:ID", :String) { prod.seller_assigned_id = it }
              end
              r.parse("cac:ClassifiedTaxCategory", :TaxCategory) { prod.tax_category = it }
            end
          end
        end
      end
    end
  end
end
