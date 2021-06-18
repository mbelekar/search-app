# frozen_string_literal: true

require './lib/validations/ticket_contract'
require 'support/validation_spec_helper'

describe Validations::TicketContract do
  include ValidationSpecHelper

  subject(:ticket_contract) { described_class.new }

  describe '#validate' do
    context 'with correct data' do
      it 'does not raise error' do
        expect { ticket_contract.validate(ticket_contr) }.not_to raise_error
      end
    end

    context 'with incorrect data' do
      it 'raises an error' do
        expect do
          ticket_contract.validate(incorrect_ticket_contr)
        end.to raise_error(Validations::TicketContract::InvalidTicketContractError)
      end
    end
  end
end
