module Tradedoc
  module Model
    # Provides a simple interface for models where you can define the attributes it has
    # and the correct types for each, and providing some simple coercion.
    #
    # @example
    #   class DocumentLine < Base
    #     has :id, String
    #     has :amount, Money
    #   end
    #
    #   class Document < Base
    #     has :id, String
    #     has :issued_at, Time
    #     has_many :lines, Line
    #   end
    class Base
      Element = Data.define(:name, :type, :many)

      def initialize(**attrs)
        attrs.each { |key, value| public_send(:"#{key}=", value) }
      end

      class << self
        def has(name, type)
          def_element(name, type, false)

          ivar_name = :"@#{name}"

          define_method(name) { instance_variable_get(ivar_name) }

          define_method("#{name}=") do |value|
            value_to_write = self.class.coerce_for(name, value)
            instance_variable_set(ivar_name, value_to_write)
          end
        end

        def has_many(name, type, default: -> { [] })
          def_element(name, type, true)

          ivar_name = :"@#{name}"

          define_method(name) do
            unless instance_variable_defined?(ivar_name)
              instance_variable_set(ivar_name, default.call)
            end

            instance_variable_get(ivar_name)
          end

          define_method("#{name}=") do |values|
            value_to_write = values.map { |value| self.class.coerce_for(name, value) }
            instance_variable_set(ivar_name, value_to_write)
          end
        end

        def inherited(subclass)
          subclass.inherit_elements(elements)
          super
        end

        def elements
          @elements ||= {}
        end

        def inherit_elements(other)
          @elements ||= {}
          @elements = @elements.merge(other)
        end

        def coerce_for(element_name, value)
          proper_type = elements.fetch(element_name).type

          case value
          in ^proper_type | nil => as_is
            as_is
          in other
            if proper_type < Base
              proper_type.new(**other)
            elsif proper_type.respond_to?(:parse)
              proper_type.parse(other)
            else
              proper_type.new(other)
            end
          end
        end

        private

        def def_element(name, type, many)
          elements[name] = Element.new(name:, type:, many:)
        end
      end

      def merge(other)
        to_h.deep_merge(other.to_h)
      end

      def to_h
        self.class.elements.keys.each_with_object({}) do |k, h|
          h[k] = case send(k)
          in nil
            nil
          in Array => arr
            arr.map do |item|
              item.respond_to?(:to_h) ? item.to_h : item
            end
          in obj if obj.respond_to?(:to_h)
            obj.to_h
          in other
            other
          end
        end
      end

      def ==(other)
        case other
        in nil
          false
        in Hash
          to_h == other
        in obj if obj.respond_to?(:to_h)
          to_h == other.to_h
        in unmatched
          raise "can't compare #{self.class.name} to #{unmatched}"
        end
      end

      def hash
        to_h.hash
      end

      def eql?(other)
        to_h == other
      end

      def deconstruct_keys(keys)
        to_h.slice(*keys)
      end
    end
  end
end
