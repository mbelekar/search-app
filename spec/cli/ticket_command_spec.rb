# frozen_string_literal: true

require './lib/cli/main_command'
require './lib/cli/ticket_command'
require './lib/application'

describe CLI::TicketCommand do
  subject(:cmd) { described_class.new('search tickets') }
  let(:mock_app) { instance_double(Application) }
  let(:tickets) { double }

  before do
    allow(Application).to receive(:new).and_return(mock_app)
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
  end
end
