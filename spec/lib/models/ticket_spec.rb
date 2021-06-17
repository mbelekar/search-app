require './lib/models/ticket'
require 'support/model_spec_helper'

describe Models::Ticket do
  include ModelSpecHelper

  subject(:ticket) { described_class.new(ticket_h) }

  context '#new' do
    it 'initializes attributes with correct values' do
      ticket_h.each do |key, value|
        expect(ticket.method(key).call).to eq(value)
      end
    end

    it 'returns correct hash' do
      expected = ticket_h.map {|k, v| [k.to_s, v] }.to_h
      expect(ticket.to_h).to eq(expected)
    end
  end
end