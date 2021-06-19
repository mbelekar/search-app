# frozen_string_literal: true

require './lib/cli/main_command'
require './lib/cli/ticket_command'
require './lib/application'
require 'support/spec_helpers/cli_spec_helper'

describe CLI::TicketCommand do
  include CliSpecHelper

  subject(:cmd) { described_class.new('search tickets') }

  let(:mock_app) { instance_double(Application) }

  before do
    allow(Application).to receive(:new).and_return(mock_app)
  end

  context 'when help' do
    let(:help_output) { tickets_help_output }

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
      allow(mock_app).to receive(:run).with(:tickets, { _id: '1jhsj1', type: 'foo' })
      cmd.run(['--_id=1jhsj1', '--type=foo'])
      expect(cmd.any_option_selected?).to be true
    end

    it 'passes options to the method' do
      allow(mock_app).to receive(:run).with(:tickets, { _id: 'eyt2hgsd', type: 'bar' })
      cmd.run(['--_id=eyt2hgsd', '--type=bar'])
      expect(mock_app).to have_received(:run).with(:tickets, { _id: 'eyt2hgsd', type: 'bar' }).once
    end

    context 'when incorrect type' do
      it 'raises error' do
        allow(mock_app).to receive(:run).with(:tickets, { assignee_id: 'abc' })
        expect { cmd.run(['--assignee_id=abc}']) }.to raise_error(Clamp::UsageError)
      end
    end

    context 'with correct type' do
      let(:opt_h) { opt_h_ticket }

      it 'does not raise error' do
        opt_h.each do |key, value|
          allow(mock_app).to receive(:run).with(:tickets, { key => value })
          expect { cmd.run(["--#{key}=#{value}"]) }.not_to raise_error
        end
      end
    end
  end
end
