# frozen_string_literal: true

require './lib/loader'
require './lib/json_parser'
require 'support/spec_helpers/data_spec_helper'

describe Loader do
  include DataSpecHelper

  subject(:loader) { described_class.new(config, parser) }

  let(:parser) { JsonParser.new }

  let(:config) do
    {
      'type' => 'json',
      'path' => {
        'users' => 'spec/support/fixtures/users',
        'tickets' => 'spec/support/fixtures/tickets'
      }
    }
  end

  context 'when load' do
    describe '#call' do
      context 'when :users' do
        let(:file_path) { 'spec/support/fixtures/users' }

        it 'loads users data from multiple files in expected format' do
          loader.call('users', file_path)
          expect(loader.data['users']).to eq(parsed_files_data_u)
        end
      end

      context 'when :tickets' do
        let(:file_path) { 'spec/support/fixtures/tickets' }

        it 'loads tickets data from multiple files in expected format' do
          loader.call('tickets', file_path)
          expect(loader.data['tickets']).to eq(parsed_files_data_t)
        end
      end
    end
  end
end
