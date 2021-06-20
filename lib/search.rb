# frozen_string_literal: true

class Search
  attr_reader :users, :tickets, :results

  def initialize(usr, tkt)
    @users = usr
    @tickets = tkt
    @results = []
  end

  def run(type, options)
    case type
    when :users then search_users(options)
    when :tickets then search_tickets(options)
    end
  end

  private

  def select_criteria(record, options)
    sel = []
    options.each do |k, v|
      value = record.method(k).call
      sel << if v.is_a? Array
               included?(value, v)
             else
               (value == v)
             end
    end
    sel
  end

  def included?(actual, opt_values)
    sel = []
    opt_values.each do |val|
      sel << actual.include?(val)
    end
    !sel.include?(false)
  end

  def filter(arr, options)
    arr.lazy.select { |a| a unless select_criteria(a, options).any?(false) }
  end

  def search_users(options)
    usr = filter(@users, options)
    usr.each do |u|
      @results.push(users_results(u))
    end
    @results
  end

  def search_tickets(options)
    tkt = filter(@tickets, options)
    tkt.each do |t|
      @results.push(tickets_results(t))
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

  def tickets_results(t)
    {
      tickets: t,
      related: {
        users: filter(@users, { _id: t.assignee_id })
      }
    }
  end
end
