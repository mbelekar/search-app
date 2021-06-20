# frozen_string_literal: true

require './lib/loader'
require './lib/parser'
require 'support/spec_helpers/data_spec_helper'

describe Loader do
  include DataSpecHelper

  subject(:loader) { described_class.new(config, Parser.new) }

  let(:config) do
    {
      'users' => 'spec/support/fixtures/users',
      'tickets' => 'spec/support/fixtures/tickets'
    }
  end

  describe '#call' do
    let(:expected) { parsed_files_data }

    it 'parses all the files and loads data as expected' do
      loader.call
      expect(loader.data).to eq(expected)
    end
  end
end
