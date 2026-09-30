module Tradedoc
  module Format
    module UBL
      module Coder
        class TradeParty
          VAT_SCHEME = "VAT"
          private_constant :VAT_SCHEME

          def self.ruby_type
            Model::TradeParty
          end

          def self.dump(w, obj, as: "Party")
            w.add(as) do
              w.add("cac:PartyName") do
                w.add("cbc:Name", obj.name)
              end
              w.render(obj.address, as: "PostalAddress")
              w.render(obj.vat_number) do |vat_number|
                w.add("cac:PartyTaxScheme") do
                  w.add("cbc:CompanyID", vat_number)
                  w.add("cac:TaxScheme") do
                    w.add("cbc:ID", VAT_SCHEME, schemeAgencyID: Code::Agency::CEFACT)
                  end
                end
              end
              w.render(obj.legal_registration_id) do |id|
                w.add("cac:PartyLegalEntity") do
                  w.add("cbc:CompanyID", id)
                end
              end
              w.render(obj.contact, as: "cac:Contact")
            end
          end

          def self.parse(r)
            obj = ruby_type.new

            r.with_node("cac:Party") do
              r.with_node("cac:PartyName") do
                r.parse("cbc:Name", :String) { obj.name = it }
              end
              r.parse("cac:PostalAddress", :Address) { obj.address = it }
              r.parse("cac:Contact", :Contact) { obj.contact = it }
              r.parse("cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='#{VAT_SCHEME}']/cbc:CompanyID", :String) do
                obj.vat_number = it
              end
              r.with_node("cac:PartyLegalEntity") do
                r.parse("cbc:CompanyID", :String) { obj.legal_registration_id = it }
              end
            end

            obj
          end
        end
      end
    end
  end
end
