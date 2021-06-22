# frozen_string_literal: true

require './lib/data_builder'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'

describe DataBuilder do
  include DataSpecHelper
  include ModelSpecHelper

  subject(:builder) { described_class.new(config, loader, transformer_klass) }

  let(:config) do
    {
      'type' => 'json',
      'path' => {
        'users' => 'spec/support/fixtures/users',
        'tickets' => 'spec/support/fixtures/tickets'
      }
    }
  end

  let(:loader) { Loader.new(config, Factories::ParserFactory.for(:json).new) }
  let(:transformer_klass) { Transformer }

  describe '#run' do
    let(:parsed_data) { parsed_files_data }
    let(:users) { hash_to_model(parsed_data['users'], Models::User) }
    let(:tickets) { hash_to_model(parsed_data['tickets'], Models::Ticket) }
    let(:expected) do
      {
        'users' => model_to_h(users),
        'tickets' => model_to_h(tickets)
      }
    end

    it 'loads files and builds data arrays' do
      builder.run
      actual = builder.data
      actual['users'] = model_to_h(actual['users'])
      actual['tickets'] = model_to_h(actual['tickets'])
      expect(actual).to eq(expected)
    end

    it 'raises error if config path is nil' do
      config['path'] = nil
      expect do
        described_class.new(config, loader, transformer_klass).run
      end.to raise_error(DataBuilder::InvalidConfigKeyError)
    end

    it 'raises error for empty config path' do
      config['path'] = {}
      expect do
        described_class.new(config, loader, transformer_klass)
      end.to raise_error(DataBuilder::InvalidConfigKeyError)
    end
  end
end
