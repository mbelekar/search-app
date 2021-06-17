# frozen_string_literal: true

module CLI
  class TicketCommand < BaseCommand
    option '--_id', '', 'Ticket Id'
    option '--created_at', '', 'Ticket Creation Timestamp'
    option '--type', '', 'Ticket Type'
    option '--subject', '', 'Ticket Subject'
    option '--assignee_id', '', 'Ticket Assigner Id' do |s|
      Integer(s)
    end
    option '--tags', '', 'Ticket Tags', multivalued: true

    def execute
      signal_usage_error 'You must select atleast one option' unless any_option_selected?
    end
  end
end
