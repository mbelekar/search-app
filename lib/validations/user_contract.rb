# frozen_string_literal: true

require 'dry/validation'
require './lib/types'

module Validations
  class UserContract < Dry::Validation::Contract
    class InvalidUserContractError < StandardError; end

    config.validate_keys = true

    schema do
      optional(:_id).value(Types::Strict::Integer | Types::Strict::Nil)
      optional(:name).value(Types::Strict::String | Types::Strict::Nil)
      optional(:created_at).value(Types::Strict::String | Types::Strict::Nil)
      optional(:verified).value(Types::Strict::Bool | Types::Strict::Nil)
    end

    def validate(data)
      validation = call(data)

      return data if validation.success?

      raise(InvalidUserContractError, "Error validating User _id #{data[:_id]} - #{validation.errors.to_h}")
    end
  end
end
