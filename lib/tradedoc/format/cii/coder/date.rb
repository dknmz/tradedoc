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
        class Date
          # https://service.unece.org/trade/untdid/d00b/tred/tred2379.htm
          FORMATS = {
            "2" => "%d%m%y",
            "3" => "%m%d%y",
            "4" => "%d%m%Y",
            "101" => "%y%m%d",
            "102" => "%Y%m%d"
          }
          ISO_EL_NAME = "udt:Date"
          UN_EL_NAME = "udt:DateTimeString"

          private_constant :FORMATS, :ISO_EL_NAME, :UN_EL_NAME

          def self.ruby_type
            ::Date
          end

          # @param format_id [String]
          #   If specified, uses a pre-defined UN/CEFACT format with a `udt:DateTimeString`
          #   If not, an `xsd:Date` with ISO is used. Both are valid
          def self.dump(w, obj, as:, format_id: "102")
            w.add(as) do
              if format_id
                fmt = FORMATS.fetch(format_id)
                w.add(UN_EL_NAME, obj.strftime(fmt), format: format_id)
              else
                w.add(ISO_EL_NAME, obj.iso8601)
              end
            end
          end

          def self.parse(r)
            r.with_node(ISO_EL_NAME) do
              return ruby_type.parse(r.text)
            end

            r.with_node(UN_EL_NAME) do
              format_id = r.attribute("format")
              return ruby_type.strptime(r.text(FORMATS.fetch(format_id)))
            end
          end
        end
      end
    end
  end
end
