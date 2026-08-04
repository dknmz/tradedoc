RSpec.describe("Remittance Advice") do
  let(:model) do
    Tradedoc::Model::RemittanceAdvice.new(
      id: "RA-12345",
      issue_date: Date.new(2026, 7, 24),
      note: "Payment for invoice",
      invoice_period: {
        start_date: Date.new(2026, 7, 13),
        end_date: Date.new(2026, 7, 13)
      },
      buyer: {
        name: "ACME Purchasing Corp.",
        address: {
          street_name: "Ørestads Boulevard",
          city: "Copenhagen",
          postal_code: "2300",
          country: {iso_code: "DK", name: "Denmark"},
          subdivision: {}
        },
        contact: {
          name: "Jens Sørensen",
          email: "js@acme.test"
        }
      },
      supplier: {
        name: "TradeCo Widgets SRL",
        address: {
          street_name: "Strada Miriana",
          city: "Milan",
          postal_code: "20149",
          country: {iso_code: "IT", name: "Italy"},
          subdivision: {code: "MI", name: "Milano"}
        },
        contact: {
          name: "Vincenzo de Luca",
          email: "vinny@tradeco.test"
        }
      },
      lines: [
        {
          id: "1",
          # debit_amount: Money.new(123456, "EUR"),
          balance_amount: Money.new(123456, "EUR"),
          document_reference: {
            id: "INV-1234",
            uuid: "aae060e8-9b73-49f5-9c9e-322f9567c778",
            type: :commercial_invoice,
            issue_date: Date.new(2026, 7, 13)
          },
          exchange_rate: {
            source_currency_code: "EUR",
            target_currency_code: "USD",
            rate: BigDecimal("1.18"),
            date: Date.new(2026, 7, 13),
            market_id: "ECB"
          }
        }
      ],
      # total_debit_amount: Money.new(123456, "EUR"),
      total_payment_amount: Money.new(123456, "EUR"),
      payment_means: {
        type_code: :debit_transfer,
        payment_id: "pay_ewuORTH7LDTZTV3p",
        sending_account: {
          scheme_name: "IBAN",
          account_number: "DK9520000123456789"
        },
        receiving_account: {
          scheme_name: "IBAN",
          account_number: "IT75512108001245126199"
        }
      }
    )
  end

  describe "CII" do
    let(:doc_format) { Tradedoc::Format::CII }
    subject(:built) { doc_format.dump(model) }

    it "can serialize to XML" do
      expect(built).to(be_a(Nokogiri::XML::Document))
    end

    it "can serialize to XML via #dump" do
      expect(model.dump(doc_format)).to(be_a(Nokogiri::XML::Document))
      expect(model.dump(:cii)).to(be_a(Nokogiri::XML::Document))
      expect(model.dump("CII")).to(be_a(Nokogiri::XML::Document))
    end

    it "passes XSD validation" do
      validate_schema(built, "spec/format/cii/xsd/remittance_advice/CrossIndustryRemittanceAdvice_100pD25A.xsd")
    end

    it "can be parsed back into a model" do
      parsed = Tradedoc::Format::CII.parse(built)
      expect(parsed).to(eq(model))
    end
  end

  describe "UBL" do
    let(:doc_format) { Tradedoc::Format::UBL }
    subject(:built) { doc_format.dump(model) }

    it "can serialize to XML" do
      expect(built).to(be_a(Nokogiri::XML::Document))
    end

    it "can serialize to XML via #dump" do
      expect(model.dump(doc_format)).to(be_a(Nokogiri::XML::Document))
      expect(model.dump(:ubl)).to(be_a(Nokogiri::XML::Document))
      expect(model.dump("UBL")).to(be_a(Nokogiri::XML::Document))
    end

    it "passes XSD validation" do
      validate_schema(built, "spec/format/ubl/xsd/maindoc/UBL-RemittanceAdvice-2.4.xsd")
    end

    it "can be parsed back into a model" do
      parsed = doc_format.parse(built)
      expect(parsed).to(eq(model))
    end

    it "can parse sample files" do
      xml = File.read("spec/format/ubl/samples/UBL-RemittanceAdvice-2.0-Example.xml")
      expect(doc_format.parse(xml)).to(be_a(Tradedoc::Model::RemittanceAdvice))
    end
  end
end
