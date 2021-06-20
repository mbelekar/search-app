require './lib/filter_results'

module Search
  class UserSearch
    include FilterResults

    attr_reader :users, :tickets, :results

    def initialize(data)
      @users = data["users"]
      @tickets = data["tickets"]
      @results = []
    end

    def run(options)
      search_users(options)
    end

    private

    def search_users(options)
      usr = filter(@users, options)
      usr.each do |u|
        @results.push(users_results(u))
      end
      @results
    end

    def users_results(u)
      {
        users: u,
        related: {
          tickets: filter(@tickets, { assignee_id: u._id })
        }
      }
    end
  end
end