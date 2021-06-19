# frozen_string_literal: true

require './lib/validations/ticket_contract'
require './lib/validations/user_contract'

module Factories
  class ValidationFactory
    class InvalidContractTypeError < StandardError; end
    VALIDATIONS = {
      tickets: Validations::TicketContract,
      users: Validations::UserContract
    }.freeze

    def self.for(type)
      VALIDATIONS[type] or raise InvalidContractTypeError
    end
  end
end
