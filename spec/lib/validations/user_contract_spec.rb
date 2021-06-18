require './lib/validations/user_contract'
require 'support/validation_spec_helper'

describe Validations::UserContract do
  include ValidationSpecHelper

  subject(:user_contract) { described_class.new }

  context '#validate' do
    context 'with correct data' do
      it 'does not raise error' do
        expect { user_contract.validate(user_contr) }.not_to raise_error
      end
    end

    context 'with incorrect data' do
      it 'raises an error' do
        expect { user_contract.validate(incorrect_user_contr) }.to raise_error(Validations::UserContract::InvalidUserContractError)
      end
    end
  end
end