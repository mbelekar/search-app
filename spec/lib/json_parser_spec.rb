# frozen_string_literal: true

require './lib/json_parser'
require 'support/custom_matchers/parser_matcher'

describe JsonParser do
  subject(:parser) { described_class.new }

  describe '#hash_start' do
    it 'returns an empty hash' do
      expect(parser.hash_start).to eq({})
    end
  end

  describe '#parse_file' do
    let(:fh) { double }

    it 'calls #Oj.sc_parse with correct args' do
      expect(parser).to invoke_sc_parse(Oj, :sc_parse, parser, 'foo')
    end
  end

  describe '#hash_set' do
    it 'sets hash record' do
      expect(parser.hash_set({}, 'id', 1)).to eq(1)
    end
  end

  describe '#aray_start' do
    it 'returns empty array' do
      expect(parser.array_start).to eq([])
    end
  end

  describe '#array_append' do
    it 'appends to array' do
      expect(parser.array_append([], 100)).to eq([100])
    end
  end

  describe '#add_value' do
    it 'adds passed value' do
      parser.add_value(3)
      expect(parser.data).to eq([3])
    end
  end

  describe '#error' do
    it 'prints correct message to stdout' do
      out = "ERROR: Invalid at line 2, column 3\n"
      expect { parser.error('Invalid', 2, 3) }.to output(out).to_stdout
    end

    it 'raises error with invalid json' do
      file = 'spec/support/fixtures/error_files/users.json'
      expect { parser.parse_file(file) }.to raise_error(Oj::ParseError)
    end
  end
end
