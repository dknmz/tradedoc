RSpec.describe(Tradedoc::Model::Invoice) do
  describe "APEH" do
    let(:sample_xml) { File.read("spec/format/apeh/samples/invoice.xml") }

    it "can be identified as APEH" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::APEH))
    end
  end

  describe "CII" do
    let(:sample_xml) { File.read("spec/format/cii/samples/CII_example1.xml") }

    it "can be identified as CII" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::CII))
    end

    it "can parse a sample file" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))
    end

    it "can parse a sample file and dump it back to valid CII" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))

      validate_schema(parsed.dump(:cii), "spec/format/cii/xsd/data/standard/CrossIndustryInvoice_100pD16B.xsd")
    end
  end

  describe "FacturaE" do
    it "can detect different versions" do
      Dir.glob("spec/format/facturae/facturae-*.{xml,xsig}").each do |path|
        sample_xml = File.read(path)
        expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::FacturaE))
      end
    end
  end

  describe "FatturaPA" do
    let(:sample_xml) { File.read("spec/format/fatturapa/samples/IT01234567890_FPR02.xml") }

    it "can be identified as FatturaPA" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::FatturaPA))
    end
  end

  describe "ISDOC" do
    let(:sample_xml) { File.read("spec/format/isdoc/samples/invoice.isdoc") }

    it "can be identified as ISDOC" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::ISDOC))
    end
  end

  describe "KSeF" do
    let(:sample_xml) { File.read("spec/format/ksef/samples/invoice-template-fa-3-with-custom-Subject2.xml") }

    it "can be identified as KSeF" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::KSEF))
    end
  end

  describe "myDATA" do
    let(:sample_xml) { File.read("spec/format/mydata/samples/SampleXML_1.1_taxes_per_line_MYDATA_GR.xml") }

    it "can be identified as myDATA" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::MyData))
    end
  end

  describe "NAV" do
    let(:sample_xml) { File.read("spec/format/nav/samples/invoice.xml") }

    it "can be identified as NAV" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::NAV))
    end
  end

  describe "UBL" do
    let(:sample_xml) { File.read("spec/format/ubl/samples/UBL-Invoice-2.1-Example.xml") }

    it "can be identified as FatturaPA" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::UBL))
    end

    it "can parse a sample file" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))
    end

    it "can parse a sample file and dump it back to valid UBL" do
      parsed = Tradedoc.parse(sample_xml)
      expect(parsed).to(be_a(described_class))

      validate_schema(parsed.dump(:ubl), "spec/format/ubl/xsd/maindoc/UBL-Invoice-2.4.xsd")
    end
  end

  describe "ZUGFeRD V1" do
    let(:sample_xml) { File.read("spec/format/zugferdv1/samples/ZUGFeRD-invoice.xml") }

    it "can be identified as ZUGFeRD V1" do
      expect(Tradedoc.detect(sample_xml)[0]).to(eq(Tradedoc::Format::ZugferdV1))
    end
  end
end
