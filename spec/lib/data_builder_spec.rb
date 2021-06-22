# frozen_string_literal: true

require './lib/data_builder'
require 'support/spec_helpers/data_spec_helper'

describe DataBuilder do
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
  let(:loader) { instance_double('Loader') }
  let(:transformer_klass) { Transformer }
  let(:transformer) { instance_double('Transformer') }
  let(:data) do
    {
      'tickets' => [],
      'users' => []
    }
  end
  let(:transformed_data) { [] }

  before do
    allow(Loader).to receive(:new).and_return(loader)

    config['path'].each do |key, value|
      allow(loader).to receive(:call).with(key, value).and_return(data)
      allow(Transformer).to receive(:new).with(key).and_return(transformer)
    end
    allow(transformer).to receive(:call).with(data).and_return(transformed_data)
  end

  describe '#new' do
    let(:type) { :foo }

    it 'raises error if config type is nil' do
      config['type'] = nil
      expect do
        described_class.new(config, loader, transformer_klass)
      end.to raise_error(DataBuilder::InvalidConfigKeyError)
    end
  end

  describe '#run' do
    let(:type) { :json }

    it 'Loader is called once for users data type' do
      builder.run
      expect(loader).to have_received(:call).with('users', config['path']['users']).once
    end

    it 'Loader is called once for tickets data type' do
      builder.run
      expect(loader).to have_received(:call).with('tickets', config['path']['tickets']).once
    end

    it 'Transformer is called twice (once per data type)' do
      builder.run
      expect(transformer).to have_received(:call).with(data).twice
    end
  end
end
