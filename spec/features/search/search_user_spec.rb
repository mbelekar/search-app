# frozen_string_literal: true

require './lib/search/user_search'
require 'support/custom_matchers/search_matcher'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe Search::UserSearch do
  include ModelSpecHelper
  include DataSpecHelper
  include SearchSpecHelper

  subject(:search) { described_class.new(data) }

  let(:data) do
    { 'users' => usr, 'tickets' => tkt }
  end
  let(:usr) { hash_to_model(user_data, ModelSpecHelper::MockUser) }
  let(:tkt) { hash_to_model(ticket_data, ModelSpecHelper::MockTicket) }

  context 'with search users' do
    let(:options) do
      {
        _id: 1,
        name: 'foo'
      }
    end

    let(:expected) do
      [
        {
          users: nil,
          related: {
            tickets: []
          }
        }
      ]
    end

    context 'when matched users and related tickets' do
      it 'returns correct results' do
        expected.first[:users] = user_data.first.transform_keys(&:to_s)
        expected.first[:related][:tickets] = [ticket_data.first.transform_keys(&:to_s)]
        expect(search).to find_data_w_related_entity(:run, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when it doesnt find a match for users' do
      it 'returns empty array' do
        options[:_id] = 23
        expected = []
        expect(search).to find_data_w_related_entity(:run, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when it finds matching users but empty tickets' do
      let(:tkt) { hash_to_model(ticket_data_a, ModelSpecHelper::MockTicket) }
      let(:search) { described_class.new({ 'users' => usr, 'tickets' => tkt }) }

      it 'returns user with empty array for tickets' do
        expected.first[:users] = user_data.first.transform_keys(&:to_s)
        expected.first[:related][:tickets] = []
        expect(search).to find_data_w_related_entity(:run, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when one of the option is nil' do
      subject(:search) { described_class.new({ 'users' => usr, 'tickets' => tkt }) }

      let(:options) do
        {
          _id: nil,
          name: 'qux'
        }
      end
      let(:usr) { hash_to_model(user_data_a, ModelSpecHelper::MockUser) }
      let(:tkt) { hash_to_model(ticket_data_a, ModelSpecHelper::MockTicket) }

      it 'return correct data' do
        expected.first[:users] = user_data_a[2].transform_keys(&:to_s)
        expected.first[:related][:tickets] = [ticket_data_a.last.transform_keys(&:to_s)]
        expect(search).to find_data_w_related_entity(:run, options, expected,
                                                     :process_user_results)
      end
    end
  end
end
