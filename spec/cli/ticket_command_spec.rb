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
end