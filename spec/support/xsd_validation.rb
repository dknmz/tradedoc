module Tradedoc
  module Test
    module XSDValidation
      def validate_schema(xml_doc, schema_file)
        # XSD files use relative paths, so we have to chdir to have them resolve properly
        dir = File.dirname(schema_file)
        fname = File.basename(schema_file)
        schema = Dir.chdir(dir) { Nokogiri::XML::Schema.new(File.read(fname)) }

        errors = schema.validate(xml_doc)
        msg = errors.map { |err| "#{err.path}:\n  #{err.message}" }.join("\n")

        expect(errors).to(be_empty, msg)
      end
    end
  end
end
