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
