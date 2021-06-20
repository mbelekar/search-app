# frozen_string_literal: true

module SearchSpecHelper
  def process_user_results(results)
    users = results.map { |r| r[:users].to_h }
    tickets = results.map { |r| r[:related][:tickets].to_a.map(&:to_h) }.flatten
    [users, tickets]
  end
end
