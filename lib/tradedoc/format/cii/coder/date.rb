module Tradedoc
  module Format
    module CII
      module Coder
        # Dates and times are a bit special.
        # (This is written for DateTime but this applies to plain Date too)
        #
        # Sometimes they're used as `udt:DateTime` which on its own, is an element
        # requiring a child that is ONE OF: `udt:DateTimeString` or `xsd:DateTime`.
        # Other times, like `qdt:FormattedIssueDateTime`, it can *only* have a `udt:DateTimeString`.
        # Since there have been no observed cases of a type not allowing `DateTimeString`,
        # the default is to generate those. We'll parse either format though.
        #
        # This class is called `Date`, but it does get used with schema elements
        # that are technically a DateTime, so it supports formats for time as well.
        # The reason for this: most DateTime fields in CII are only Date fields
        # in other formats and often, a time component doesn't make sense anyway.
        # For example: invoice date. No need for time.
        class Date
          # https://service.unece.org/trade/untdid/d00b/tred/tred2379.htm
          FORMATS = {
            "2" => "%d%m%y",
            "3" => "%m%d%y",
            "4" => "%d%m%Y",
            "101" => "%y%m%d",
            "102" => "%Y%m%d",

            # These are of course time formats, but it allows us to read and write
            # Time fields as if they're Dates and we get all zeroes for the time components.
            "204" => "%Y%m%d%H%M%S",
            "205" => "%Y%m%d%H%M%z"
          }
          NS_U = "udt"
          NS_Q = "qdt"
          ISO_EL_NAME = "#{NS_U}:Date"
          UN_EL_NAME = "DateTimeString"
          DEFAULT_DATE_FORMAT = "102"
          DEFAULT_TIME_FORMAT = "205"

          private_constant :NS_U, :NS_Q, :ISO_EL_NAME, :UN_EL_NAME
          private_constant :FORMATS, :DEFAULT_DATE_FORMAT, :DEFAULT_TIME_FORMAT

          def self.ruby_type
            ::Date
          end

          # @param obj [Date | Time]
          # @param format_id [String]
          #   ID of a pre-defined UN/CEFACT format with a `udt:DateTimeString`
          #   Use "ISO", or :iso to render an `xsd:Date` with ISO formatting.
          # @param qualified [Boolean]
          #   Some time fields use "qualified" times which have the same formats
          #   as non-qualified, but they use a different namespace.
          def self.dump(w, obj, as:, format_id: nil, qualified: false)
            if format_id.nil?
              format_id = obj.is_a?(::Date) ? DEFAULT_DATE_FORMAT : DEFAULT_TIME_FORMAT
            end

            w.add(as) do
              if format_id.to_s.casecmp?("iso")
                w.add(ISO_EL_NAME, obj.iso8601)
              else
                ns = qualified ? NS_Q : NS_U
                fmt = FORMATS.fetch(format_id)
                w.add("#{ns}:#{UN_EL_NAME}", obj.strftime(fmt), format: format_id)
              end
            end
          end

          def self.parse(r)
            # Only one of these nodes will match
            r.with_node(ISO_EL_NAME) do
              return ruby_type.parse(r.text)
            end

            [NS_Q, NS_U].each do |ns|
              r.with_node("#{ns}:#{UN_EL_NAME}") do
                format_id = r.attribute("format")
                return ruby_type.strptime(r.text, FORMATS.fetch(format_id))
              end
            end
          end
        end
      end
    end
  end
end
