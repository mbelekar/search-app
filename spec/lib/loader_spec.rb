# frozen_string_literal: true

require './lib/loader'
require 'support/custom_matchers'
require 'support/spec_helpers/data_spec_helper'

describe Loader do
  include DataSpecHelper

  subject(:loader) { described_class.new(config, parser) }

  let(:parser) { instance_double('Parser') }
  let(:config) do
    {
      'users' => 'spec/support/fixtures/users',
      'tickets' => 'spec/support/fixtures/tickets'
    }
  end

  context 'when load' do
    describe '#load' do
      it 'loads data for a single file in expected format' do
        allow(parser).to receive(:parse_file).with('foo')
        allow(parser).to receive(:data).and_return(user_data)
        loader.send(:load, 'foo')
        expect(loader.data_for_type).to eq(user_data)
      end
    end

    describe '#call' do
      context 'when :users' do
        let(:file_path) { 'spec/support/fixtures/users' }
        let(:kwargs) do
          {
            type: 'users',
            expected: parsed_files_data_u,
            stubbed_ret: [user_data, user_data_a]
          }
        end

        it 'loads users data from multiple files in expected format' do
          expect(loader).to load_files_for_type(parser, file_path, kwargs)
        end
      end

      context 'when :tickets' do
        let(:file_path) { 'spec/support/fixtures/tickets' }
        let(:kwargs) do
          {
            type: 'tickets',
            expected: parsed_files_data_t,
            stubbed_ret: [ticket_data, ticket_data_a]
          }
        end

        it 'loads tickets data from multiple files in expected format' do
          expect(loader).to load_files_for_type(parser, file_path, kwargs)
        end
      end
    end
  end
end
