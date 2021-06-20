# frozen_string_literal: true

require './lib/factories/builder_factory'

describe Factories::BuilderFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct builder for given type' do
      factory::BUILDERS.each do |type, builder|
        expect(factory.for(type)).to eq(builder)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidBuilderTypeError)
    end
  end
end
