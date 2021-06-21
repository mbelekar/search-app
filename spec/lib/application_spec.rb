# frozen_string_literal: true

require './lib/application'
require './lib/search/user_search'
require './lib/search/ticket_search'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'
require 'support/custom_matchers'

describe Application do
  include DataSpecHelper
  include ModelSpecHelper

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
      let(:users) { hash_to_model(user_data, Models::User) }
      let(:options) do
        {
          _id: 1,
          name: 'foo'
        }
      end
      let(:data) { {'users' => nil, 'tickets' => []} }
      let(:search) { Search::UserSearch.new(data) }

      it 'calls expected methods' do
        expect(application).to run_invokes_configure_and_search_methods(application, data, search, options)
      end
    end

    context 'when search tickets' do
      subject(:application) { described_class.new(:tickets, config) }
      let(:tickets) { hash_to_model(ticket_data, Models::Ticket) }
      let(:options) do
        {
          _id: '34357-fh7gy77',
          tags: %w[bar baz]
        }
      end
      let(:data) { {'users' => nil, 'tickets' => []} }
      let(:search) { Search::TicketSearch.new(data) }

      it 'calls expected methods' do
        expect(application).to run_invokes_configure_and_search_methods(application, data, search, options)
      end
    end
  end
end