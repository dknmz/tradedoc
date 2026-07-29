RSpec.describe("Remittance Advice") do
  def validate_schema(xml_doc, schema_file)
    # XSD files use relative paths, so we have to chdir to have them resolve properly
    dir = File.dirname(schema_file)
    fname = File.basename(schema_file)
    schema = Dir.chdir(dir) { Nokogiri::XML::Schema.new(File.read(fname)) }

    errors = schema.validate(xml_doc)
    msg = errors.map { |err| "#{err.path}:\n  #{err.message}" }.join("\n")

    expect(errors).to(be_empty, msg)
  end

  let(:model) do
    Tradedoc::Model::RemittanceAdvice.new(
      id: "RA-12345",
      issued_at: Time.new(2026, 7, 24, 0, 0, 0),
      note: "Payment for invoice",
      invoice_period: {
        starts_at: Time.new(2026, 7, 13, 0, 0, 0),
        ends_at: Time.new(2026, 7, 13, 0, 0, 0)
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
              issued_at: Time.new(2026, 7, 13, 0, 0, 0)
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
    it "can serialize to XML" do
      expect(Tradedoc::Format::CII::Document.dump(model)).to(be_a(Nokogiri::XML::Document))
    end

    it "passes XSD validation" do
      doc = Tradedoc::Format::CII::Document.dump(model)
      validate_schema(doc, "spec/xsd/cii/remittance_advice/CrossIndustryRemittanceAdvice_100pD23B.xsd")
    end

    it "can be parsed back into a model" do
      doc = Tradedoc::Format::CII::Document.dump(model)
      parsed = Tradedoc::Format::CII::Document.parse(doc)
      expect(parsed).to(eq(model))
    end
  end
end
