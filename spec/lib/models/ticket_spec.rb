# frozen_string_literal: true

require './lib/models/ticket'
require 'support/spec_helpers/model_spec_helper'

describe Models::Ticket do
  include ModelSpecHelper

  subject(:ticket) { described_class.new(ticket_h) }

  describe '#new' do
    it 'initializes attributes with correct values' do
      ticket_h.each do |key, value|
        expect(ticket.method(key).call).to eq(value)
      end
    end

    it 'returns correct hash' do
      expected = ticket_h.transform_keys(&:to_s)
      expect(ticket.to_h).to eq(expected)
    end
  end
end
