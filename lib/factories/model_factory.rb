# frozen_string_literal: true

require './lib/models/ticket'
require './lib/models/user'

module Factories
  class ModelFactory
    class InvalidModelTypeError < StandardError; end
    MODELS = {
      tickets: Models::Ticket,
      users: Models::User
    }.freeze

    def self.for(type)
      MODELS[type] or raise InvalidModelTypeError
    end
  end
end
