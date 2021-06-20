# frozen_string_literal: true

require './lib/validations/ticket_contract'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/validation_spec_helper'

describe Validations::TicketContract do
  include DataSpecHelper
  include ValidationSpecHelper

  subject(:ticket_contract) { described_class.new }

  describe '#validate' do
    context 'with correct data' do
      it 'does not raise error' do
        ticket_data_a.each do |ticket|
          expect { ticket_contract.validate(ticket) }.not_to raise_error
        end
      end
    end

    context 'with incorrect data' do
      it 'raises an error' do
        expect do
          ticket_contract.validate(incorrect_ticket_contr)
        end.to raise_error(Validations::TicketContract::InvalidTicketContractError)
      end
    end

    context 'with nil value' do
      it 'does not raise an error' do
        expect { ticket_contract.validate(nil_values_ticket_contr) }.not_to raise_error
      end
    end

    context 'with empty string value' do
      it 'does not raise an error' do
        expect { ticket_contract.validate(empty_values_ticket_contr) }.not_to raise_error
      end
    end
  end
end
