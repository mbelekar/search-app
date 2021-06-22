# frozen_string_literal: true

require './lib/transformer'
require 'support/spec_helpers/model_spec_helper'

describe Transformer do
  include ModelSpecHelper

  subject(:transformer) { described_class.new(type) }

  let(:type) { 'users' }

  context 'when initialized' do
    it 'uses correct type' do
      expect(transformer.type).to eq(:users)
    end

    it 'uses correct contract' do
      expect(transformer.contract).to be_instance_of(Validations::UserContract)
    end

    it 'uses correct model' do
      expect(transformer.model).to eq(Models::User)
    end
  end

  describe '#call' do
    let(:data) { user_h }

    before do
      allow(transformer.contract).to receive(:validate).with(data).and_return(data)
      allow(transformer.model).to receive(:new).with(data)
    end

    it 'does contract validation' do
      transformer.call([data])
      expect(transformer.contract).to have_received(:validate).with(data).once
    end

    it 'creates model with validated data' do
      transformer.call([data])
      expect(transformer.model).to have_received(:new).with(data).once
    end
  end
end
