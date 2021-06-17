# frozen_string_literal: true

require './lib/application'

module CLI
  class TicketCommand < BaseCommand
    option '--_id', '', 'Ticket Id'
    option '--created_at', '', 'Ticket Creation Timestamp'
    option '--type', '', 'Ticket Type'
    option '--assignee_id', '', 'Ticket Assignee Id (Should be a number)' do |s|
      Integer(s)
    end
    option '--tags', '', 'Ticket Tags', multivalued: true

    def execute
      signal_usage_error 'You must select atleast one option' unless any_option_selected?
      Application.new.run(:tickets, options_h)
    end
  end
end
