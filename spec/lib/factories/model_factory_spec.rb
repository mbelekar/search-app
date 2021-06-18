# frozen_string_literal: true

require './lib/factories/model_factory'

describe Factories::ModelFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct model for given type' do
      factory::MODELS.each do |type, model|
        expect(factory.for(type)).to eq(model)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidModelTypeError)
    end
  end
end
