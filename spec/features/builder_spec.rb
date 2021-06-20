# frozen_string_literal: true

require './lib/builder'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'
require 'support/custom_matchers'

describe Builder do
  include ModelSpecHelper
  include DataSpecHelper

  context 'when build users data' do
    subject(:builder) { described_class.new('users') }

    let(:type) { 'users' }
    let(:data) { parsed_files_data_u }
    let(:expected) { model_data(data, builder.model) }

    it 'builds expected array of models' do
      actual = builder.call(data)
      actual.each_with_index do |a, i|
        expect(a).to be_instance_of(Models::User)
        expect(a.to_h).to eq(expected[i].to_h)
      end
    end
  end

  context 'when build tickets data' do
    subject(:builder) { described_class.new('tickets') }

    let(:data) { parsed_files_data_t }
    let(:expected) { model_data(data, builder.model) }

    it 'builds expected array of models' do
      actual = builder.call(data)
      actual.each_with_index do |a, i|
        expect(a).to be_instance_of(Models::Ticket)
        expect(a.to_h).to eq(expected[i].to_h)
      end
    end
  end
end
