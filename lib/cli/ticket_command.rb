# frozen_string_literal: true

require './lib/application'

module CLI
  class TicketCommand < BaseCommand
    option '--_id', '', 'Ticket Id'
    option '--created_at', '', 'Ticket Creation Timestamp'
    option '--type', '', 'Ticket Type'
    option '--subject', '', 'Ticket Subject'
    option '--assignee_id', '', 'Ticket Assignee Id (Should be a number)' do |s|
      Integer(s) unless s.nil?
    end
    option '--tags', '', 'Ticket Tags (Supports searching multiple values at once)', multivalued: true

    def execute
      signal_usage_error 'You must select atleast one option' unless any_option_selected?
      Application.new(:tickets).run(options_h)
    end
  end
end
