# frozen_string_literal: true

require 'yaml'
require './lib/cli/main_command'

class Application
  attr_reader :tickets, :users

  def run(type, *kwargs); end
end
