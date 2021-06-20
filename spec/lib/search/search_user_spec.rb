require './lib/search/user_search'
require 'support/custom_matchers'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe Search::UserSearch do
  include ModelSpecHelper
  include DataSpecHelper
  include SearchSpecHelper

  subject(:search) { described_class.new(data) }
  let(:data) do
    {"users" => usr, "tickets" => tkt}
  end
  let(:usr) { hash_to_model(user_data, ModelSpecHelper::MockUser) }
  let(:tkt) { hash_to_model(ticket_data, ModelSpecHelper::MockTicket) }

  describe '#search_users' do
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
        expected.first[:users] = ModelSpecHelper::MockUser.new(user_data.first).to_h
        expected.first[:related][:tickets] = [ModelSpecHelper::MockTicket.new(ticket_data.first).to_h]
        expect(search).to find_data_w_related_entity(:search_users, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when it doesnt find a match for users' do
      it 'returns empty array' do
        options[:_id] = 23
        expected = []
        expect(search).to find_data_w_related_entity(:search_users, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when it finds matching users but empty tickets' do
      let(:tkt) { hash_to_model(ticket_data_a, ModelSpecHelper::MockTicket) }
      let(:search) { described_class.new({"users" => usr, "tickets" => tkt}) }

      it 'returns user with empty array for tickets' do
        expected.first[:users] = ModelSpecHelper::MockUser.new(user_data.first).to_h
        expected.first[:related][:tickets] = []
        expect(search).to find_data_w_related_entity(:search_users, options, expected,
                                                     :process_user_results)
      end
    end

    context 'when one of the option is nil' do
      let(:options) do
        {
          _id: nil,
          name: 'qux'
        }
      end
      let(:usr) { hash_to_model(user_data_a, ModelSpecHelper::MockUser) }
      let(:tkt) { hash_to_model(ticket_data_a, ModelSpecHelper::MockTicket) }
      subject(:search) { described_class.new({"users" => usr, "tickets" => tkt}) }

      it 'return correct data' do
        expected.first[:users] = ModelSpecHelper::MockUser.new(user_data_a[2]).to_h
        expected.first[:related][:tickets] = [ModelSpecHelper::MockTicket.new(ticket_data_a[2]).to_h]
        expect(search).to find_data_w_related_entity(:search_users, options, expected,
                                                     :process_user_results)
      end
    end
  end
end