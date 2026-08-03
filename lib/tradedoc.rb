# frozen_string_literal: true

require "bigdecimal"
require "nokogiri"
require "money"

module Tradedoc
  Error = Class.new(StandardError)
end

# no dependencies
require_relative "tradedoc/version"
require_relative "tradedoc/xml"
require_relative "tradedoc/code"

# may have dependencies and order may matter
require_relative "tradedoc/format"
require_relative "tradedoc/model"

module Tradedoc
  # List of formats supports for reading and writing documents
  #
  # @return [Set<Module>]
  def self.formats
    Set[Format::CII, Format::UBL]
  end

  # Detect the format and document type of a given source
  #
  # @return [Array<Module, Class>]
  def self.detect(source)
    xml = xml_from(source)
    formats.each do |fmt|
      if (dt = fmt.detect_document_coder(xml))
        return [fmt, dt]
      end
    end
  end

  # Given an XML document or XML string, detect the format, document type, and
  # parse it into a model.
  #
  # Returns `nil` when the format or document type isn't supported.
  #
  # @param source [Nokogiri::XML::Document | String]
  # @return [Object]
  def self.parse(source)
    xml = xml_from(source)
    if detect(xml) in [fmt, coder]
      fmt.parse(xml, coder:)
    end
  end

  # Get a format by a flexible source selector
  #
  # @param source [Symbol | String | Module]
  # @return [Module]
  def self.format_from(source)
    case source
    in Module => m if formats.include?(m)
      m
    in String | Symbol => name
      name = name.to_s
      formats.detect { it.label.casecmp?(name) || it.name.split("::").last.casecmp?(name) }
    end
  end

  # @param source [String | Nokogiri::XML::Document]
  # @return [Nokogiri::XML::Document]
  def self.xml_from(source)
    case source
    in Nokogiri::XML::Document => doc
      doc
    in String => str
      Nokogiri::XML.parse(str)
    end
  end
end
