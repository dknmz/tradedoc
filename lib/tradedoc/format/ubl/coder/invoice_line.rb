module Tradedoc
  module Format
    module UBL
      module Coder
        class InvoiceLine
          def self.ruby_type
            Model::InvoiceLine
          end

          def self.dump(w, obj, as: "cac:InvoiceLine")
            w.add(as) do
              w.render(obj.id, as: "cbc:ID")
              w.render(obj.invoiced_quantity, as: "cbc:InvoicedQuantity")
              w.render(obj.total_excluding_tax, as: "LineExtensionAmount")
              if (total_tax = obj.total_tax)
                w.add("cac:TaxTotal") do
                  w.render(total_tax, as: "TotalTax")
                end
              end

              w.render(obj.product)

              if (price = obj.price)
                w.add("cac:Price") do
                  w.render(price.net, as: "PriceAmount")
                  w.render(price.base_quantity, as: "cbc:BaseQuantity")
                end
              end
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |line|
              r.parse("cbc:ID", :String) { line.id = it }
              r.parse("cbc:InvoicedQuantity", :BigDecimal) { line.invoiced_quantity = it }
              r.parse("cbc:LineExtensionAmount", :Money) { line.total_excluding_tax = it }
              r.with_node("cac:TaxTotal") do
                r.parse("cbc:TotalTax", :Money) { line.total_tax = it }
              end
              r.parse("cac:Item", :Product) { line.product = it }
              r.with_node("cac:Price") do
                line.price = Model::Price.new.tap do |price|
                  r.parse("cbc:PriceAmount", :Money) { price.net = it }
                  r.parse("cbc:BaseQuantity", :BigDecimal) { price.base_quantity = it }
                end
              end
            end
          end
        end
      end
    end
  end
end
