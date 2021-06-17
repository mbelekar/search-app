# frozen_string_literal: true

require './lib/cli/main_command'
require './lib/cli/user_command'
require './lib/application'
require 'support/cli_spec_helper'

describe CLI::UserCommand do
  include CliSpecHelper

  subject(:cmd) { described_class.new('search users') }

  let(:mock_app) { instance_double(Application) }

  before do
    allow(Application).to receive(:new).and_return(mock_app)
  end

  context 'when help' do
    let(:help_output) { users_help_output }

    it 'describes usage when help method is invoked' do
      expect(cmd.help).to match(help_output)
    end
  end

  context 'when called with no options' do
    it 'raises help error' do
      expect { cmd.run([]) }.to raise_error(Clamp::UsageError)
    end
  end

  context 'when called with options' do
    it 'returns true if options are selected' do
      allow(mock_app).to receive(:run).with(:users, { _id: 1, name: 'foo' })
      cmd.run(['--_id=1', '--name=foo'])
      expect(cmd.any_option_selected?).to be true
    end

    it 'passes options to the method' do
      allow(mock_app).to receive(:run).with(:users, { _id: 1, name: 'foo' })
      cmd.run(['--_id=1', '--name=foo'])
      expect(mock_app).to have_received(:run).with(:users, { _id: 1, name: 'foo' }).once
    end

    context 'when incorrect type' do
      let(:opt_h) { incorrect_opt_h_user }

      it 'raises error' do
        opt_h.each do |key, value|
          allow(mock_app).to receive(:run).with(:users, { key => value })
          expect { cmd.run(["--#{key}=#{value}"]) }.to raise_error(Clamp::UsageError)
        end
      end
    end

    context 'with correct type' do
      let(:opt_h) { opt_h_user }

      it 'does not raise error' do
        opt_h.each do |key, value|
          allow(mock_app).to receive(:run).with(:users, { key => value })
          expect { cmd.run(["--#{key}=#{value}"]) }.not_to raise_error
        end
      end
    end
  end
end
