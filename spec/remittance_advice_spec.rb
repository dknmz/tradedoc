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
          country: {iso_code: "DK", name: "Denmark"}
        }
      },
      supplier: {
        name: "TradeCo Widgets",
        address: {
          street_name: "Eppendorfer Landstraße",
          city: "Hamburg",
          postal_code: "20251",
          country: {iso_code: "DE", name: "Germany"}
        }
      },
      lines: [
        {
          id: "1",
          # debit_amount: Money.new(123456, "EUR"),
          balance_amount: Money.new(123456, "EUR"),
          billing_reference: {
            type: :commercial_invoice,
            document_reference: {
              id: "INV-1234",
              uuid: "aae060e8-9b73-49f5-9c9e-322f9567c778",
              issue_date: Date.new(2026, 7, 13)
            }
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
          account_number: "DE75512108001245126199"
        }
      }
    )
  end

  describe "CII" do
    subject(:built) { Tradedoc::Format::CII::Document.dump(model) }

    it "can serialize to XML" do
      expect(built).to(be_a(Nokogiri::XML::Document))
    end

    it "passes XSD validation" do
      validate_schema(built, "spec/format/cii/xsd/remittance_advice/CrossIndustryRemittanceAdvice_100pD23B.xsd")
    end

    it "can be parsed back into a model" do
      parsed = Tradedoc::Format::CII::Document.parse(built)
      expect(parsed).to(eq(model))
    end
  end

  describe "UBL" do
    subject(:built) { Tradedoc::Format::UBL::Document.dump(model) }

    it "can serialize to XML" do
      expect(built).to(be_a(Nokogiri::XML::Document))
    end

    it "passes XSD validation" do
      validate_schema(built, "spec/format/ubl/xsd/maindoc/UBL-RemittanceAdvice-2.4.xsd")
    end

    it "can be parsed back into a model" do
      parsed = Tradedoc::Format::UBL::Document.parse(built)
      expect(parsed).to(eq(model))
    end
  end
end
