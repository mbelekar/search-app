# frozen_string_literal: true

require './lib/filter_results'
require 'support/custom_matchers'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe FilterResults do
  include ModelSpecHelper
  include DataSpecHelper
  include SearchSpecHelper

  let(:dummy_class) { Class.new { include FilterResults } }
  let(:subject) { dummy_class.new }

  let(:usr) { hash_to_model(user_data, ModelSpecHelper::MockUser) }
  let(:tkt) { hash_to_model(ticket_data, ModelSpecHelper::MockTicket) }

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
          actual = subject.send(:select_criteria, usr.first, options)
          expect(actual).not_to include(false)
        end
      end

      context 'when options and user record attributes have partial match' do
        it 'has true values for matched options and false values for unmatched options' do
          options[:name] = 'bar'
          actual = subject.send(:select_criteria, usr.first, options)
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
          actual = subject.send(:select_criteria, usr.first, options)
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
          actual = subject.send(:select_criteria, tkt.first, options)
          expect(actual).not_to include(false)
        end
      end

      context 'when options and ticket record attributes have partial match' do
        it 'has true values for matched options and false values for unmatched options' do
          options[:type] = 'bar'
          actual = subject.send(:select_criteria, tkt.last, options)
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
          actual = subject.send(:select_criteria, tkt.first, options)
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
          actual = subject.send(:filter, usr, options).to_a.map(&:to_h)
          expected = [ModelSpecHelper::MockUser.new(user_data.first).to_h]
          expect(actual).to eq(expected)
        end
      end

      context 'when any of the options do not match with user record attributes' do
        it 'does not select record' do
          options[:name] = 'baz'
          actual = subject.send(:filter, usr, options).to_a.map(&:to_h)
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
          actual = subject.send(:filter, tkt, options).to_a.map(&:to_h)
          expected = [ModelSpecHelper::MockTicket.new(ticket_data.last).to_h]
          expect(actual).to eq(expected)
        end
      end

      context 'when any of the options do not match with ticket record attributes' do
        it 'does not select record' do
          options[:tags] = %w[abc bar]
          actual = subject.send(:filter, tkt, options).to_a.map(&:to_h)
          expect(actual).to match_array([])
        end
      end
    end
  end
end
