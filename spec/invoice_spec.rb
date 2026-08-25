RSpec.describe(Tradedoc::Model::Invoice) do
  subject(:parsed) { Tradedoc.parse(sample_xml) }

  let(:comprehensive_model) do
    Tradedoc::Model::Invoice.new(
      invoice_number: "INV-260824-40000",
      issue_date: Date.new(2026, 8, 24),
      invoice_type_code: "380",
      currency_code: "EUR",
      due_date: Date.new(2026, 9, 30),
      purchase_order_number: "PO-12345",
      note: "Please pay promptly",
      specification_id: "urn:cen.eu:en16931:2017",
      invoice_period: {
        start_date: Date.new(2026, 7, 1),
        end_date: Date.new(2026, 7, 31)
      },
      payment_means: [
        {
          receiving_account: {
            scheme_name: "IBAN",
            account_number: "010000001"
          }
        },
        {
          receiving_account: {
            scheme_name: "SWIFT",
            account_number: "02000002",
            financial_institution: {
              id: "DKDKABCD"
            }
          }
        }
      ]
    )
  end

  shared_examples_for "format identification" do |expected_format|
    # We'll assume the parent `describe` block is the name/label of the format
    expected_format ||= metadata.dig(:parent_example_group, :description)

    it "identifies the document as #{expected_format}" do
      expect(Tradedoc.detect(sample_xml)[0].label).to(eq(expected_format))
    end
  end

  shared_examples_for "parsing essential attributes" do
    it "includes invoice essentials" do
      expect(parsed).to(have_attributes(
        issue_date: be_a(Date),
        invoice_number: be_a(String),
        invoice_type_code: "380",
        currency_code: be_a(String),
        due_date: be_a(Date)
      ))
    end

    it "includes payment means" do
      expect(parsed.payment_means.count).to(be_positive)
      expect(parsed.payment_means).to(all(have_attributes(
        type_code: be_a(Tradedoc::Code::PaymentMeansType),
        receiving_account: be_a(Tradedoc::Model::FinancialAccount)
      )))
    end

    it "include supplier details" do
      expect(parsed.supplier).to(have_attributes(
        name: be_a(String)
      ))
      expect(parsed.buyer.address).to(have_attributes(
        country: be_a(Tradedoc::Model::Country)
      ))
    end

    it "include buyer details" do
      expect(parsed.buyer).to(have_attributes(
        name: be_a(String)
      ))
      expect(parsed.buyer.address).to(have_attributes(
        country: be_a(Tradedoc::Model::Country)
      ))
    end

    it "includes monetary totals" do
      expect(parsed.monetary_total).to(have_attributes(
        line_items_tax_exclusive: be_a(Money),
        tax_exclusive: be_a(Money),
        tax_inclusive: be_a(Money),
        payable: be_a(Money)
      ))

      expect(parsed.monetary_total.tax_breakdown).to(have_attributes(
        total_tax: be_a(Money)
      ))
    end

    it "include line items" do
      line_items = parsed.line_items

      expect(line_items.count).to(be_positive)

      expect(line_items).to(all(have_attributes(
        id: be_a(String),
        total_excluding_tax: be_a(Money)
      )))

      expect(line_items.map(&:product)).to(all(have_attributes(
        name: be_a(String)
      )))

      expect(line_items.map(&:price)).to(all(have_attributes(
        net: be_a(Money)
      )))
    end
  end

  shared_examples_for "serializing essential attributes" do
    # We'll assume the parent `describe` block is the name/label of the format
    format_name ||= metadata.dig(:parent_example_group, :description)
    fmt = Tradedoc.format_from(format_name)

    it "can serialize an empty model" do
      empty_model = Tradedoc::Model::Invoice.new

      expect(empty_model.dump(fmt)).to(be_a(Nokogiri::XML::Document))
    end

    it "can serialize a comprehensive model" do
      expect(comprehensive_model.dump(fmt)).to(be_a(Nokogiri::XML::Document))
    end
  end

  describe "APEH" do
    let(:sample_xml) { File.read("spec/format/apeh/samples/invoice.xml") }

    it_behaves_like "format identification"
  end

  describe "CII" do
    let(:sample_xml) { File.read("spec/format/cii/samples/CII_example1.xml") }

    it_behaves_like "format identification"
    it_behaves_like "parsing essential attributes"
    it_behaves_like "serializing essential attributes"

    it "can parse a sample file and dump it back to valid CII" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))

      validate_schema(parsed.dump(:cii), "spec/format/cii/xsd/data/standard/CrossIndustryInvoice_100pD16B.xsd")
    end
  end

  describe "FacturaE" do
    Dir.glob("spec/format/facturae/samples/facturae-*.{xml,xsig}").each do |path|
      context "with #{File.basename(path)}" do
        let(:sample_xml) { File.read(path) }
        it_behaves_like "format identification", "FacturaE"
      end
    end
  end

  describe "FatturaPA" do
    let(:sample_xml) { File.read("spec/format/fatturapa/samples/IT01234567890_FPR02.xml") }

    it_behaves_like "format identification"
  end

  describe "ISDOC" do
    let(:sample_xml) { File.read("spec/format/isdoc/samples/invoice.isdoc") }

    it_behaves_like "format identification"
  end

  describe "KSeF" do
    let(:sample_xml) { File.read("spec/format/ksef/samples/invoice-template-fa-3-with-custom-Subject2.xml") }

    it_behaves_like "format identification"
  end

  describe "myDATA" do
    let(:sample_xml) { File.read("spec/format/mydata/samples/SampleXML_1.1_taxes_per_line_MYDATA_GR.xml") }

    it_behaves_like "format identification"
  end

  describe "NAV" do
    let(:sample_xml) { File.read("spec/format/nav/samples/invoice.xml") }

    it_behaves_like "format identification"
  end

  describe "UBL" do
    let(:sample_xml) { File.read("spec/format/ubl/samples/UBL-Invoice-2.1-Example.xml") }

    it_behaves_like "format identification"
    it_behaves_like "parsing essential attributes"
    it_behaves_like "serializing essential attributes"

    it "can parse a sample file and dump it back to valid UBL" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))

      validate_schema(parsed.dump(:ubl), "spec/format/ubl/xsd/maindoc/UBL-Invoice-2.4.xsd")
    end
  end

  describe "ZUGFeRDv1" do
    let(:sample_xml) { File.read("spec/format/zugferdv1/samples/ZUGFeRD-invoice.xml") }

    it_behaves_like "format identification"
  end
end
