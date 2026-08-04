module Tradedoc
  module Format
    module UBL
      module Coder
        class DocumentReference
          DREF_SUFFIX = "DocumentReference"

          # Element names are based on the document type.
          # Map based on our internal document type IDs.
          TYPE_MAP = {
            commercial_invoice: "Invoice",
            credit_note: "CreditNote",
            debit_note: "DebitNote"
          }

          private_constant :DREF_SUFFIX, :TYPE_MAP

          def self.ruby_type
            Model::DocumentReference
          end

          def self.dump(w, obj, as:)
            element_name_root = TYPE_MAP.fetch(obj.type.id)

            w.add(as) do
              w.add("cac:#{element_name_root}#{DREF_SUFFIX}") do
                w.add("cbc:ID", obj.id)
                w.add("cbc:UUID", obj.uuid)
                w.render(obj.issue_date, as: "IssueDate")
              end
            end
          end

          def self.parse(r)
            # The type of the document reference is embedded in the node name, so we
            # have to match that manually to derive the type and pick the right child node.
            dr_node = r.node.children.detect { it.node_name.end_with?(DREF_SUFFIX) }

            return if dr_node.nil?

            ruby_type.new.tap do |dr|
              dr.type = TYPE_MAP.key(dr_node.node_name.delete_suffix(DREF_SUFFIX))

              r.with_node(dr_node) do
                r.parse("cbc:ID", :String) { dr.id = it }
                r.parse("cbc:UUID", :String) { dr.uuid = it }
                r.parse("cbc:IssueDate", :Date) { dr.issue_date = it }
              end
            end
          end
        end
      end
    end
  end
end
