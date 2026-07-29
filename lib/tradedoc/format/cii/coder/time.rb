module Tradedoc
  module Format
    module CII
      module Coder
        class Time
          # https://service.unece.org/trade/untdid/d00b/tred/tred2379.htm
          FORMATS = {
            "204" => "%Y%m%d%H%M%S",
            "205" => "%Y%m%d%H%M%z"
          }
          UN_EL_NAME = "DateTimeString"
          ISO_EL_NAME = "udt:DateTime"

          private_constant :FORMATS, :UN_EL_NAME, :ISO_EL_NAME

          def self.ruby_type
            ::Time
          end

          # @param qualified [Boolean]
          #   Some time fields use "qualified" times which have the same formats
          #   as non-qualified, but they use a different namespace.
          def self.dump(w, obj, as:, format_id: "205", qualified: false)
            ns = qualified ? "qdt" : "udt"

            w.add(as) do
              if format_id
                fmt = FORMATS.fetch(format_id)
                w.add("#{ns}:#{UN_EL_NAME}", obj.strftime(fmt), format: format_id)
              else
                w.add(ISO_EL_NAME, obj.utc.iso8601)
              end
            end
          end

          def self.parse(r)
            # only one of these nodes is going to be present
            r.with_node(ISO_EL_NAME) do
              return ruby_type.parse(r.text)
            end

            r.with_node("qdt:#{UN_EL_NAME}") do
              format_id = r.attribute("format")
              return ruby_type.strptime(r.text, FORMATS.fetch(format_id))
            end

            r.with_node("udt:#{UN_EL_NAME}") do
              format_id = r.attribute("format")
              return ruby_type.strptime(r.text, FORMATS.fetch(format_id))
            end
          end
        end
      end
    end
  end
end
