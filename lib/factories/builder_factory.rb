# frozen_string_literal: true

require './lib/builder'

module Factories
  class BuilderFactory
    class InvalidBuilderTypeError < StandardError; end
    BUILDERS = {
      json: Builder
    }.freeze

    def self.for(type)
      BUILDERS[type] or raise InvalidBuilderTypeError
    end
  end
end