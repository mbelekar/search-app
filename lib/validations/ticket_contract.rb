# frozen_string_literal: true

require 'dry/validation'
require './lib/types'

module Validations
  class TicketContract < Dry::Validation::Contract
    class InvalidTicketContractError < StandardError; end

    config.validate_keys = true

    schema do
      optional(:_id).value(Types::Strict::String)
      optional(:created_at).value(Types::Strict::String)
      optional(:type).value(Types::Strict::String)
      optional(:subject).value(Types::Strict::String)
      optional(:assignee_id).value(Types::Strict::Integer)
      optional(:tags).value(Types::Strict::Array.of(Types::Strict::String))
    end

    def validate(data)
      validation = call(data)

      return data if validation.success?

      raise(InvalidTicketContractError, "Error validating ticket _id #{data[:_id]} - #{validation.errors.to_h}")
    end
  end
end
