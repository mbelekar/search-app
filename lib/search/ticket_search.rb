# frozen_string_literal: true

require './lib/filter_results'

module Search
  class TicketSearch
    include FilterResults

    attr_reader :tickets, :users, :results

    def initialize(data)
      @users = data['users']
      @tickets = data['tickets']
      @results = []
    end

    def run(options)
      search_tickets(options)
    end

    private

    def search_tickets(options)
      tkt = filter(@tickets, options)
      tkt.each do |t|
        @results.push(tickets_results(t))
      end
      @results
    end

    def tickets_results(t)
      {
        tickets: t,
        related: {
          users: filter(@users, { _id: t.assignee_id })
        }
      }
    end
  end
end
