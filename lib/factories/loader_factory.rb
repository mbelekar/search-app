# frozen_string_literal: true

require './lib/loader'

module Factories
  class LoaderFactory
    class InvalidLoaderTypeError < StandardError; end
    LOADERS = {
      json: Loader
    }.freeze

    def self.for(type)
      LOADERS[type] or raise InvalidLoaderTypeError
    end
  end
end
