# frozen_string_literal: true

require './lib/factories/parser_factory'

describe Factories::ParserFactory do
  subject(:factory) { described_class }

  describe '#self.for' do
    it 'invokes correct parser for given type' do
      factory::PARSERS.each do |type, parser|
        expect(factory.for(type)).to eq(parser)
      end
    end

    it 'raises error for invalid type' do
      expect { factory.for('foo') }.to raise_error(factory::InvalidParserTypeError)
    end
  end
end
