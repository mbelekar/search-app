# frozen_string_literal: true

require './lib/search/ticket_search'
require 'support/custom_matchers'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe Search::TicketSearch do
  include ModelSpecHelper
  include DataSpecHelper
  include SearchSpecHelper

  subject(:search) { described_class.new(data) }

  let(:data) do
    { 'users' => usr, 'tickets' => tkt }
  end
  let(:usr) { hash_to_model(user_data, ModelSpecHelper::MockUser) }
  let(:tkt) { hash_to_model(ticket_data, ModelSpecHelper::MockTicket) }

  describe '#search_tickets' do
    let(:options) do
      {
        _id: '545-fhj-87hg8',
        tags: %w[bar baz]
      }
    end
    let(:expected) do
      [
        {
          tickets: nil,
          related: {
            users: []
          }
        }
      ]
    end

    context 'when matched tickets and related users' do
      it 'returns correct results' do
        expected.first[:tickets] = ModelSpecHelper::MockTicket.new(ticket_data.first).to_h
        expected.first[:related][:users] = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
        expect(search).to find_data_w_related_entity(:search_tickets, options, expected, :process_ticket_results)
      end
    end

    context 'when it doesnt find a match for tickets' do
      it 'returns empty array' do
        options[:_id] = '23'
        expected = []
        expect(search).to find_data_w_related_entity(:search_tickets, options, expected, :process_ticket_results)
      end
    end

    context 'when it finds matching tickets but empty users' do
      let(:usr) { hash_to_model(user_data_a, ModelSpecHelper::MockUser) }
      let(:search) { described_class.new({ 'users' => usr, 'tickets' => tkt }) }

      it 'returns ticket with empty array for users' do
        expected.first[:tickets] = ModelSpecHelper::MockTicket.new(ticket_data.first).to_h
        expected.first[:related][:users] = []
        expect(search).to find_data_w_related_entity(:search_tickets, options, expected, :process_ticket_results)
      end
    end

    context 'when one of the option is nil' do
      subject(:search) { described_class.new({ 'users' => usr, 'tickets' => tkt }) }

      let(:options) do
        {
          assignee_id: nil,
          type: 'foo'
        }
      end
      let(:tkt) { hash_to_model(ticket_data_a, ModelSpecHelper::MockTicket) }
      let(:usr) { hash_to_model(user_data_a, ModelSpecHelper::MockUser) }

      it 'return correct data' do
        expected.first[:tickets] = ModelSpecHelper::MockTicket.new(ticket_data_a[2]).to_h
        expected.first[:related][:users] = [ModelSpecHelper::MockUser.new(user_data_a[2]).to_h]
        expect(search).to find_data_w_related_entity(:search_tickets, options, expected,
                                                     :process_ticket_results)
      end
    end
  end
end
