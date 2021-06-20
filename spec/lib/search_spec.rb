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
          expect(actual).to include(false)
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
          expect(actual).to include(false)
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
          expect(actual).to include(false)
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
          expect(actual).to include(false)
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
          expected = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
          expect(actual).not_to eq(expected)
        end
      end
    end

    context 'when tickets' do
      let(:options) do
        {
          _id: '34357-fh7gy77',
          tags: %w[bar baz qux quux]
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
          expected = [ModelSpecHelper::MockTicket.new(ticket_data.last).to_h]
          expect(actual).not_to eq(expected)
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

    context 'when matched users and related tickets' do
      it 'returns correct results' do
        expected_users = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
        expected_tickets = [ModelSpecHelper::MockTicket.new(ticket_data.first).to_h]
        expect(search).to find_users_w_related_tickets(options, expected_users, expected_tickets,
                                                       method(:process_user_results))
      end
    end

    context 'when it doesnt find a match for users' do
      it 'returns empty array' do
        options[:_id] = 23
        expected_users = []
        expected_tickets = []
        expect(search).to find_users_w_related_tickets(options, expected_users, expected_tickets,
                                                       method(:process_user_results))
      end
    end

    context 'when it finds matching users but empty tickets' do
      let(:tkt) { model_data(ticket_data_a, ModelSpecHelper::MockTicket) }
      let(:search) { described_class.new(usr, tkt) }

      it 'returns empty array for tickets' do
        expected_users = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
        expected_tickets = []
        expect(search).to find_users_w_related_tickets(options, expected_users, expected_tickets,
                                                       method(:process_user_results))
      end
    end
  end

  context 'when search tickets' do
  end
end
