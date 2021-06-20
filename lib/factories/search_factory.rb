# frozen_string_literal: true

require './lib/search/user_search'
require './lib/search/ticket_search'

module Factories
  class SearchFactory
    class InvalidSearchTypeError < StandardError; end
    SEARCH = {
      tickets: Search::TicketSearch,
      users: Search::UserSearch
    }.freeze

    def self.for(type)
      SEARCH[type] or raise InvalidSearchTypeError
    end
  end
end