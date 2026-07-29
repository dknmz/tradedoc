module Tradedoc
  module Format
    module UBL
      module Coder
        class BillingReference
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
            Model::BillingReference
          end

          def self.dump(w, obj, as:)
            ref = obj.document_reference
            return if ref.nil?

            element_name_root = TYPE_MAP.fetch(obj.type.id)

            w.add(as) do
              w.add("cac:#{element_name_root}#{DREF_SUFFIX}") do
                w.add("cbc:ID", ref.id)
                w.add("cbc:UUID", ref.uuid)
                w.render(ref.issued_at&.to_date, as: "IssueDate")
              end
            end
          end

          def self.parse(r)
            br = ruby_type.new

            # The type of the document reference is embedded in the node name, so we
            # have to match that manually to derive the type and pick the right child node.
            if (dr_node = r.node.children.detect { it.node_name.end_with?(DREF_SUFFIX) })
              br.type = TYPE_MAP.key(dr_node.node_name.delete_suffix(DREF_SUFFIX))

              r.with_node(dr_node) do
                br.document_reference = Model::DocumentReference.new.tap do |dr|
                  r.parse("cbc:ID", :String) { dr.id = it }
                  r.parse("cbc:UUID", :String) { dr.uuid = it }
                  r.parse("cbc:IssueDate", :Date) { dr.issued_at = it.to_time }
                end
              end
            end

            br
          end
        end
      end
    end
  end
end
