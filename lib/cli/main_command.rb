# frozen_string_literal: true

require 'clamp'
require './lib/cli/base_command'
require './lib/cli/ticket_command'
require './lib/cli/user_command'

module CLI
  class MainCommand < BaseCommand
    subcommand 'tickets', 'Search for ticket(s)', CLI::TicketCommand
    subcommand 'users', 'Search for user(s)', CLI::UserCommand
  end
end