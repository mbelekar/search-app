# frozen_string_literal: true

require './lib/factories/validation_factory'

describe Factories::ValidationFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct validation class for given type' do
      factory::VALIDATIONS.each do |type, validation|
        expect(factory.for(type)).to eq(validation)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidContractTypeError)
    end
  end
end
