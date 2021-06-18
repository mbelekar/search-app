# frozen_string_literal: true

require 'dry/validation'
require './lib/types'

module Validations
  class UserContract < Dry::Validation::Contract
    class InvalidUserContractError < StandardError; end

    config.validate_keys = true

    schema do
      optional(:_id).value(Types::Strict::Integer)
      optional(:name).value(Types::Strict::String)
      optional(:created_at).value(Types::Strict::String)
      optional(:verified).value(Types::Strict::Bool)
    end

    def validate(data)
      validation = call(data)

      return data if validation.success?

      raise(InvalidUserContractError, "Error validating User _id #{data[:_id]} - #{validation.errors.to_h}")
    end
  end
end
