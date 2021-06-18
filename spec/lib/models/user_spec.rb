# frozen_string_literal: true

require './lib/models/user'
require 'support/model_spec_helper'

describe Models::User do
  include ModelSpecHelper

  subject(:user) { described_class.new(user_h) }

  describe '#new' do
    it 'initializes attributes with correct values' do
      user_h.each do |key, value|
        expect(user.method(key).call).to eq(value)
      end
    end

    it 'returns correct hash' do
      expected = user_h.map { |k, v| [k.to_s, v] }.to_h
      expect(user.to_h).to eq(expected)
    end
  end
end
