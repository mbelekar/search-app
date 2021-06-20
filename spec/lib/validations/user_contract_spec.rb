# frozen_string_literal: true

require './lib/validations/user_contract'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/validation_spec_helper'

describe Validations::UserContract do
  include DataSpecHelper
  include ValidationSpecHelper

  subject(:user_contract) { described_class.new }

  describe '#validate' do
    context 'with correct data' do
      it 'does not raise error' do
        user_data_a.each do |user|
          expect { user_contract.validate(user) }.not_to raise_error
        end
      end
    end

    context 'with incorrect data' do
      it 'raises an error' do
        expect do
          user_contract.validate(incorrect_user_contr)
        end.to raise_error(Validations::UserContract::InvalidUserContractError)
      end
    end

    context 'with nil value' do
      it 'does not raise an error' do
        expect { user_contract.validate(nil_values_user_contr) }.not_to raise_error
      end
    end

    context 'with empty string value' do
      it 'does not raise an error' do
        expect { user_contract.validate(empty_values_user_contr) }.not_to raise_error
      end
    end
  end
end
