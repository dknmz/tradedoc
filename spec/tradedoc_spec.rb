# frozen_string_literal: true

RSpec.describe Tradedoc do
  it "has a version number" do
    expect(Tradedoc::VERSION).not_to be nil
  end

  describe ".detect" do
    subject(:result) { Tradedoc.detect(source) }

    context "with UBL Remittance Advice" do
      let(:source) { File.read("spec/format/ubl/samples/UBL-RemittanceAdvice-2.0-Example.xml") }

      it "detects the format and type" do
        expect(result).to(eq([Tradedoc::Format::UBL, Tradedoc::Format::UBL::Coder::RemittanceAdvice]))
      end
    end
  end

  describe ".file_extensions" do
    subject(:result) { Tradedoc.file_extensions }

    it "returns the expected set" do
      expect(result).to(eq(Set[".isdoc", ".xml", ".xsig"]))
    end
  end

  describe ".parse" do
    subject(:result) { Tradedoc.parse(source) }

    context "with UBL Remittance Advice" do
      let(:source) { File.read("spec/format/ubl/samples/UBL-RemittanceAdvice-2.0-Example.xml") }

      it "parses directly to a model" do
        expect(result).to(be_a(Tradedoc::Model::RemittanceAdvice))
      end
    end
  end
end
