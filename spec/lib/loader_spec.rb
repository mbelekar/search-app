# frozen_string_literal: true

require './lib/loader'
require 'support/custom_matchers/loader_matcher'

describe Loader do
  context 'when load json files' do
    subject(:loader) { described_class.new(config, parser) }

    let(:parser) { instance_double('JsonParser') }

    let(:config) do
      {
        'type' => 'json',
        'path' => {
          'users' => 'spec/support/fixtures/users',
          'tickets' => 'spec/support/fixtures/tickets'
        }
      }
    end

    before do
      allow(JsonParser).to receive(:new).and_return(parser)
      files.each do |file|
        allow(parser).to receive(:parse_file).with(file).and_return([])
      end
    end

    describe '#call' do
      let(:files) { Dir.glob("#{file_path}/*") }

      context 'when :users' do
        let(:file_path) { 'spec/support/fixtures/users' }

        it 'invokes json parser for multiple files' do
          expect(loader).to invoke_parser_for_each_file(parser, file_path, 'users')
        end
      end

      context 'when :tickets' do
        let(:file_path) { 'spec/support/fixtures/tickets' }

        it 'invokes json parser for tickets data from multiple files' do
          expect(loader).to invoke_parser_for_each_file(parser, file_path, 'tickets')
        end
      end
    end
  end
end
