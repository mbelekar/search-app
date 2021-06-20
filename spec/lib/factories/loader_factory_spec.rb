# frozen_string_literal: true

require './lib/factories/loader_factory'

describe Factories::LoaderFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct loader for given type' do
      factory::LOADERS.each do |type, loader|
        expect(factory.for(type)).to eq(loader)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidLoaderTypeError)
    end
  end
end
