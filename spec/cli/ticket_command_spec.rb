# frozen_string_literal: true

require './lib/cli/main_command'
require './lib/cli/ticket_command'

describe CLI::TicketCommand do
  subject(:cmd) { described_class.new('search tickets') }

  let(:tickets) { double }

  context 'when called with no options' do
    it 'raises help error' do
      expect { cmd.run([]) }.to raise_error(Clamp::UsageError)
    end
  end

  context 'when called with options' do
    it 'returns true if options are selected' do
      cmd.run(['--_id=1jhsj1', '--type=foo'])
      expect(cmd.any_option_selected?).to be true
    end
  end
end
