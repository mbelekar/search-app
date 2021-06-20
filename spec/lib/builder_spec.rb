# frozen_string_literal: true

require './lib/builder'
require 'support/spec_helpers/model_spec_helper'

describe Builder do
  include ModelSpecHelper

  subject(:builder) { described_class.new(type) }

  let(:type) { 'users' }

  context 'when initialized' do
    it 'uses correct type' do
      expect(builder.type).to eq(:users)
    end

    it 'uses correct contract' do
      expect(builder.contract).to be_instance_of(Validations::UserContract)
    end

    it 'uses correct model' do
      expect(builder.model).to eq(Models::User)
    end
  end

  describe '#call' do
    let(:data) { user_h }

    it 'does contract validation' do
      allow(builder.contract).to receive(:validate).with(data).and_return(data)
      allow(builder.model).to receive(:new).with(data)
      builder.call([data])
      expect(builder.contract).to have_received(:validate).with(data).once
    end

    it 'creates model with validated data' do
      allow(builder.contract).to receive(:validate).with(data).and_return(data)
      allow(builder.model).to receive(:new).with(data)
      builder.call([data])
      expect(builder.model).to have_received(:new).with(data).once
    end

    it 'does not create model if validation returns nil' do
      allow(builder.contract).to receive(:validate).with(data).and_return(nil)
      allow(builder.model).to receive(:new).with(data)
      builder.call([data])
      expect(builder.model).not_to have_received(:new)
    end
  end
end
