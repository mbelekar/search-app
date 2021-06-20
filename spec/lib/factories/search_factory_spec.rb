# frozen_string_literal: true

require './lib/factories/search_factory'

describe Factories::SearchFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct search for given type' do
      factory::SEARCH.each do |type, search|
        expect(factory.for(type)).to eq(search)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidSearchTypeError)
    end
  end
end
