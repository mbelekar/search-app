# frozen_string_literal: true

require './lib/cli/main_command'
require './lib/cli/user_command'

describe CLI::UserCommand do
  subject(:cmd) { described_class.new('search users') }

  let(:users) { double }

  context 'when called with no options' do
    it 'raises help error' do
      expect { cmd.run([]) }.to raise_error(Clamp::UsageError)
    end
  end

  context 'when called with options' do
    it 'returns true if options are selected' do
      cmd.run(['--_id=1', '--name=foo'])
      expect(cmd.any_option_selected?).to be true
    end
  end
end
