# frozen_string_literal: true

require 'support/custom_matchers/subcommand_matcher'
require './lib/cli/main_command'

describe CLI::MainCommand do
  subject(:cmd) { described_class.new('search') }

  describe '#run' do
    context 'when called with no options' do
      it 'raises the help error' do
        expect { cmd.run([]) }.to raise_error(Clamp::HelpWanted)
      end
    end

    context 'when called with a subcommand' do
      it 'invokes the users subcommand class' do
        expect(cmd).to invoke_subcommand(CLI::UserCommand, :users)
      end

      it 'invokes the tickets subcommand class' do
        expect(cmd).to invoke_subcommand(CLI::TicketCommand, :tickets)
      end
    end
  end
end
