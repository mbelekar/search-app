# frozen_string_literal: true

require './lib/json_parser'

module Factories
  class ParserFactory
    class InvalidParserTypeError < StandardError; end
    PARSERS = {
      json: JsonParser
    }.freeze

    def self.for(type)
      PARSERS[type] or raise InvalidParserTypeError
    end
  end
end
