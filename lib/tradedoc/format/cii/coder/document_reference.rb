module Tradedoc
  module Format
    module CII
      module Coder
        class DocumentReference
          def self.ruby_type
            Model::DocumentReference
          end

          def self.dump(w, obj, as: "ram:AssociatedReferencedDocument")
            w.add(as) do
              w.add("ram:IssuerAssignedID", obj.id)
              w.add("ram:TypeCode", obj.type.cefact_id, listAgencyID: Code::Agency::CEFACT)
              w.render(obj.uuid, as: "ram:GlobalID")
              w.render(obj.issue_date, :Date, as: "ram:FormattedIssueDateTime", qualified: true)
              w.render(obj.note, as: "ram:IncludedNote")
            end
          end

          def self.parse(r)
            ruby_type.new.tap do |dr|
              r.with_node("ram:TypeCode") { dr.type = Code::DocumentType.get(r.text) }
              r.parse("ram:IssuerAssignedID", :String) { dr.id = it }
              r.parse("ram:GlobalID", :String) { dr.uuid = it }
              r.parse("ram:IncludedNote", :String) { dr.note = it }
              r.parse("ram:FormattedIssueDateTime", :Date) { dr.issue_date = it }
            end
          end
        end
      end
    end
  end
end
