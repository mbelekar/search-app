# frozen_string_literal: true

require './lib/transformer'
require 'support/spec_helpers/data_spec_helper'
require 'support/spec_helpers/model_spec_helper'

describe Transformer do
  include ModelSpecHelper
  include DataSpecHelper

  context 'when build users data' do
    subject(:data_builder) { described_class.new(:users) }

    let(:data) { parsed_files_data_u }
    let(:expected) { hash_to_model(data, ModelSpecHelper::MockUser) }

    it 'builds expected array of models' do
      actual = data_builder.call(data)
      actual.each_with_index do |a, i|
        expect(a.to_h).to eq(expected[i].to_h)
      end
    end
  end

  context 'when build tickets data' do
    subject(:data_builder) { described_class.new(:tickets) }

    let(:data) { parsed_files_data_t }
    let(:expected) { hash_to_model(data, ModelSpecHelper::MockTicket) }

    it 'builds expected array of models' do
      actual = data_builder.call(data)
      actual.each_with_index do |a, i|
        expect(a.to_h).to eq(expected[i].to_h)
      end
    end
  end
end
