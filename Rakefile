# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '-fd'
  end

  task default: 'spec'
rescue LoadError
  puts 'No rspec available'
end
