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
      let(:users) { hash_to_model(user_data, Models::User) }
      let(:tickets) { hash_to_model(ticket_data, Models::Ticket) }
      let(:expected) do
        [
          {
            users: model_to_h(users).first,
            related: {
              tickets: [model_to_h(tickets).first]
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
      let(:users) { hash_to_model(user_data, Models::User) }
      let(:tickets) { hash_to_model(ticket_data, Models::Ticket) }
      let(:expected) do
        [
          {
            tickets: model_to_h(tickets).last,
            related: {
              users: [model_to_h(users).last]
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