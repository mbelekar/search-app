# frozen_string_literal: true

require './lib/application'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe Application do
  include DataSpecHelper
  include ModelSpecHelper
  include SearchSpecHelper

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
    allow($stdout).to receive(:write)
  end

  context 'with default config' do
    let(:default_config) do
      {
        'type' => 'json',
        'path' => {
          'users' => './data/users/',
          'tickets' => './data/tickets/'
        }
      }
    end

    it 'loads default config when no config argument is passed' do
      app = described_class.new(:users)
      expect(app.builder.config).to eq(default_config)
    end
  end

  context 'when invalid options' do
    subject(:application) { described_class.new(type, config) }

    let(:options) { {} }
    let(:type) { :users }

    it 'raises error' do
      expect { application.run(options) }.to raise_error(Application::InvalidSearchOptionError)
    end
  end

  context 'when invalid type' do
    let(:options) { { _id: 1 } }
    let(:type) { :foo }

    it 'raises error' do
      expect { described_class.new(type, config) }.to raise_error(Application::InvalidSearchTypeError)
    end
  end

  describe '#run' do
    context 'when search users' do
      subject(:application) { described_class.new(:users, config) }

      let(:options) do
        {
          _id: 1,
          name: 'foo'
        }
      end
      let(:parsed_data) { parsed_files_data }
      let(:expected) do
        [
          {
            users: user_data.first.transform_keys(&:to_s),
            related: {
              tickets: [ticket_data.first.transform_keys(&:to_s)]
            }
          }
        ]
      end

      it 'returns search results as expected' do
        actual = application.run(options)
        actual = process_user_results(actual)
        expect(actual).to eq(expected)
      end
    end

    context 'when search tickets' do
      subject(:application) { described_class.new(:tickets, config) }

      let(:options) do
        {
          _id: '34357-fh7gy77',
          tags: %w[bar baz]
        }
      end
      let(:parsed_data) { parsed_files_data }
      let(:expected) do
        [
          {
            tickets: ticket_data.last.transform_keys(&:to_s),
            related: {
              users: [user_data.last.transform_keys(&:to_s)]
            }
          }
        ]
      end

      it 'returns search results as expected' do
        actual = application.run(options)
        actual = process_ticket_results(actual)
        expect(actual).to eq(expected)
      end
    end
  end
end
