# frozen_string_literal: true

require 'dry/validation'
require './lib/types'

module Validations
  class TicketContract < Dry::Validation::Contract
    class InvalidTicketContractError < StandardError; end

    config.validate_keys = true

    schema do
      optional(:_id).value(Types::Strict::String | Types::Strict::Nil)
      optional(:created_at).value(Types::Strict::String | Types::Strict::Nil)
      optional(:type).value(Types::Strict::String | Types::Strict::Nil)
      optional(:subject).value(Types::Strict::String | Types::Strict::Nil)
      optional(:assignee_id).value(Types::Strict::Integer | Types::Strict::Nil)
      optional(:tags).value(Types::Strict::Array.of(Types::Strict::String.optional) | Types::Strict::Nil)
    end

    def validate(data)
      validation = call(data)

      return data if validation.success?

      raise(InvalidTicketContractError, "Error validating ticket _id #{data[:_id]} - #{validation.errors.to_h}")
    end
  end
end
