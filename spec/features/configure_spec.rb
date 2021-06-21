# frozen_string_literal: true

require './lib/configure'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'

describe Configure do
  include DataSpecHelper
  include ModelSpecHelper

  subject(:configure) { described_class.new(config) }

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
    let(:parsed_data) { parsed_files_data }
    let(:users) { hash_to_model(parsed_data['users'], Models::User) }
    let(:tickets) { hash_to_model(parsed_data['tickets'], Models::Ticket) }
    let(:expected) do
      {
        'users' => model_to_h(users),
        'tickets' => model_to_h(tickets)
      }
    end

    it 'configures all data as expected' do
      configure.run
      actual = configure.data
      actual['users'] = model_to_h(actual['users'])
      actual['tickets'] = model_to_h(actual['tickets'])
      expect(actual).to eq(expected)
    end
  end
end
