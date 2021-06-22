# frozen_string_literal: true

require './lib/cli/data_display'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'
require 'support/spec_helpers/search_spec_helper'

describe CLI::DataDisplay do
  include described_class
  include DataSpecHelper
  include ModelSpecHelper

  before do
    allow($stdout).to receive(:write)
  end

  context 'when display results' do
    context 'when :users' do
      let(:data) do
        [
          {
            users: hash_to_model(user_data, ModelSpecHelper::MockUser).first,
            related: {
              tickets: [hash_to_model(ticket_data, ModelSpecHelper::MockTicket).first]
            }
          }
        ]
      end

      let(:expected_data) do
        [
          :separator,
          ["\e[0;31;49m_id\e[0m", "\e[0;31;49m1\e[0m"],
          ["\e[0;31;49mname\e[0m", "\e[0;31;49mfoo\e[0m"],
          ["\e[0;31;49mcreated_at\e[0m", "\e[0;31;49m2016-04-15T05:19:46-10:00\e[0m"],
          ["\e[0;31;49mverified\e[0m", "\e[0;31;49mtrue\e[0m"],
          ["\e[0;31;49mticket_0\e[0m", "\e[0;31;49mfoo\e[0m"]
        ]
      end

      let(:expected_heading) do
        ["\e[0;32;49mAttribute\e[0m", "\e[0;32;49mValue\e[0m"]
      end

      it 'has correct table data for displaying' do
        data_display(:users, data)
        expect(@rows).to eq(expected_data)
      end

      it 'has correct table heading' do
        data_display(:users, data)
        actual = table.headings.first.cells.map(&:value)
        expect(actual).to eq(expected_heading)
      end
    end

    context 'when :tickets' do
      let(:data) do
        [
          {
            tickets: hash_to_model(ticket_data, ModelSpecHelper::MockUser).first,
            related: {
              tickets: [hash_to_model(user_data, ModelSpecHelper::MockTicket).first]
            }
          }
        ]
      end

      let(:expected_data) do
        [
          :separator,
          ["\e[0;31;49m_id\e[0m", "\e[0;31;49m545-fhj-87hg8\e[0m"],
          ["\e[0;31;49mname\e[0m", ''],
          ["\e[0;31;49mcreated_at\e[0m", "\e[0;31;49m2016-04-28T11:19:34-10:00\e[0m"],
          ["\e[0;31;49mverified\e[0m", ''],
          ["\e[0;31;49mticket_0\e[0m", '']
        ]
      end

      let(:expected_heading) do
        ["\e[0;32;49mAttribute\e[0m", "\e[0;32;49mValue\e[0m"]
      end

      it 'has correct table data for displaying' do
        data_display(:tickets, data)
        expect(@rows).to eq(expected_data)
      end

      it 'has correct table heading' do
        data_display(:tickets, data)
        actual = table.headings.first.cells.map(&:value)
        expect(actual).to eq(expected_heading)
      end
    end

    context 'when no results' do
      it 'displays human readable error message' do
        expected = "\e[0;36;49mSearching for Tickets ..\e[0m\n\n\e[0;31;49mNo results found. Try using different search options ...\e[0m\n"
        expect { data_display(:tickets, []) }.to output(expected).to_stdout
      end
    end
  end
end
