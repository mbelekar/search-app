# frozen_string_literal: true

require './lib/loader'
require 'support/custom_matchers'

describe Loader do
  subject(:loader) { described_class.new(config, parser) }

  let(:parser) { instance_double(Parser) }
  let(:config) do
    {
      'users' => 'spec/support/fixtures/users',
      'tickets' => 'spec/support/fixtures/tickets'
    }
  end

  context 'when load' do
    context 'with correct config' do

      it 'passes file path to the parser' do
        is_expected.to pass_each_file_from_config_to_parser(config, parser, loader)
      end
    end

    context 'with incorrect config' do
      it 'raises error' do
        allow(config).to receive(:each).and_yield('users', 'spec/support/users')\
                                        .and_yield('tickets','spec/support/tickets')

        expect { loader.call }.to raise_error(Loader::InvalidFilePathError)
      end
    end
  end
end
