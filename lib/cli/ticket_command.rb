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
    end
  end
end