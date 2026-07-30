module Tradedoc
  module Format
    module CII
      module Coder
        class BillingReference
          def self.ruby_type
            Model::BillingReference
          end

          def self.dump(w, obj, as: "ram:AssociatedReferencedDocument")
            w.add(as) do
              w.add("ram:IssuerAssignedID", obj.document_reference.id)
              w.add("ram:TypeCode", obj.type.cefact_id, listAgencyID: Code::Agency::CEFACT)
              w.render(obj.document_reference.uuid, as: "ram:GlobalID")
              w.render(obj.document_reference.issue_date, :Date, as: "ram:FormattedIssueDateTime", qualified: true)
              w.render(obj.document_reference.note, as: "ram:IncludedNote")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |br|
              br.document_reference = Model::DocumentReference.new.tap do |dr|
                r.parse("ram:IssuerAssignedID", :String) { dr.id = it }
                r.parse("ram:GlobalID", :String) { dr.uuid = it }
                r.parse("ram:IncludedNote", :String) { dr.note = it }
                r.parse("ram:FormattedIssueDateTime", :Date) { dr.issue_date = it }
              end

              r.with_node("ram:TypeCode") { br.type = Code::DocumentType.get(r.text) }
            end
          end
        end
      end
    end
  end
end
