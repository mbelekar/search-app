# frozen_string_literal: true

require 'yaml'
require './lib/cli/main_command'

class Application
  # rubocop:disable Lint/DuplicateMethods

  attr_reader :tickets, :users

  def run(type, *kwargs)
  end
  # rubocop:disable Lint/DuplicateMethods
end