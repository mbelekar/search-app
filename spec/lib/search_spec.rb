# frozen_string_literal: true

require './lib/search'
require 'support/custom_matchers'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe Search do
  include ModelSpecHelper
  include DataSpecHelper
  include SearchSpecHelper

  subject(:search) { described_class.new(usr, tkt) }

  let(:usr) { model_data(user_data, ModelSpecHelper::MockUser) }
  let(:tkt) { model_data(ticket_data, ModelSpecHelper::MockTicket) }

  describe '#select_criteria' do
    context 'with users data and options as input' do
      let(:options) do
        {
          _id: 1,
          name: 'foo'
        }
      end

      context 'when options and user record attributes match' do
        it 'has all true values only' do
          actual = search.send(:select_criteria, usr.first, options)
          expect(actual).not_to include(false)
        end
      end

      context 'when options and user record attributes have partial match' do
        it 'has true values for matched options and false values for unmatched options' do
          options[:name] = 'bar'
          actual = search.send(:select_criteria, usr.first, options)
          expect(actual).to include(false, true)
        end
      end

      context 'when options and user record attributes do not match' do
        let(:options) do
          {
            _id: 666,
            name: 'some name',
            created_at: '2021-06-01T11:00:00',
            verified: false
          }
        end

        it 'has false values only' do
          options[:name] = 'bar'
          actual = search.send(:select_criteria, usr.first, options)
          expect(actual).not_to include(true)
        end
      end
    end

    context 'with tickets data and options as input' do
      let(:options) do
        {
          _id: '545-fhj-87hg8',
          type: 'incident',
          tags: %w[baz qux]
        }
      end

      context 'when options and ticket record attributes match' do
        it 'has all true values only' do
          actual = search.send(:select_criteria, tkt.first, options)
          expect(actual).not_to include(false)
        end
      end

      context 'when options and ticket record attributes have partial match' do
        it 'has true values for matched options and false values for unmatched options' do
          options[:type] = 'bar'
          actual = search.send(:select_criteria, tkt.last, options)
          expect(actual).to include(false, true)
        end
      end

      context 'when options and user record attributes do not match' do
        let(:options) do
          {
            _id: '1',
            created_at: '2021-06-01T00:00:00',
            type: 'some_type',
            subject: 'some subject',
            assignee_id: 999,
            tags: %w[abc def]
          }
        end

        it 'has false values only' do
          actual = search.send(:select_criteria, tkt.first, options)
          expect(actual).not_to include(true)
        end
      end
    end
  end

  describe '#filter' do
    context 'when user' do
      let(:options) do
        {
          _id: 1,
          name: 'foo'
        }
      end

      context 'when all options match with user record attributes' do
        it 'selects matched record' do
          actual = search.send(:filter, usr, options).to_a.map(&:to_h)
          expected = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
          expect(actual).to eq(expected)
        end
      end

      context 'when any of the options do not match with user record attributes' do
        it 'does not select record' do
          options[:name] = 'baz'
          actual = search.send(:filter, usr, options).to_a.map(&:to_h)
          expect(actual).to match_array([])
        end
      end
    end

    context 'when tickets' do
      let(:options) do
        {
          _id: '34357-fh7gy77',
          tags: %w[bar baz qux]
        }
      end

      context 'when all options match with ticket record attributes' do
        it 'selects matched record' do
          actual = search.send(:filter, tkt, options).to_a.map(&:to_h)
          expected = [ModelSpecHelper::MockTicket.new(ticket_data.last).to_h]
          expect(actual).to eq(expected)
        end
      end

      context 'when any of the options do not match with ticket record attributes' do
        it 'does not select record' do
          options[:tags] = %w[abc bar]
          actual = search.send(:filter, tkt, options).to_a.map(&:to_h)
          expect(actual).to match_array([])
        end
      end
    end
  end

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
        expected[0][:users] = ModelSpecHelper::MockUser.new(user_data.first).to_h
        expected[0][:related][:tickets] = [ModelSpecHelper::MockTicket.new(ticket_data.first).to_h]
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
      let(:tkt) { model_data(ticket_data_a, ModelSpecHelper::MockTicket) }
      let(:search) { described_class.new(usr, tkt) }

      it 'returns user with empty array for tickets' do
        expected[0][:users] = ModelSpecHelper::MockUser.new(user_data.first).to_h
        expected[0][:related][:tickets] = []
        expect(search).to find_data_w_related_entity(:search_users, options, expected,
                                                     :process_user_results)
      end
    end
  end

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
        expected[0][:tickets] = ModelSpecHelper::MockTicket.new(ticket_data.first).to_h
        expected[0][:related][:users] = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
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
      let(:usr) { model_data(user_data_a, ModelSpecHelper::MockUser) }
      let(:search) { described_class.new(usr, tkt) }

      it 'returns ticket with empty array for users' do
        expected[0][:tickets] = ModelSpecHelper::MockTicket.new(ticket_data.first).to_h
        expected[0][:related][:users] = []
        expect(search).to find_data_w_related_entity(:search_tickets, options, expected, :process_ticket_results)
      end
    end
  end
end
