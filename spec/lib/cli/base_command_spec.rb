# frozen_string_literal: true

require './lib/cli/base_command'

describe CLI::BaseCommand do
  subject(:cmd) { described_class.new('search') }

  context 'when #to_bool' do
    context 'with correct input' do
      it 'does not raise an error if input is String and is either \'true\' or \'false\'' do
        %w[true false].each do |val|
          expect { cmd.to_bool(val) }.not_to raise_error
        end
      end

      it 'does not raise an error if input is Boolean and is either true or false' do
        [true, false].each do |val|
          expect { cmd.to_bool(val) }.not_to raise_error
        end
      end
    end

    context 'with incorrect input' do
      it 'raises an error if input is of incorrect type' do
        ['123', 456, 1.85].each do |val|
          expect { cmd.to_bool(val) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
