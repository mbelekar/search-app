# frozen_string_literal: true

module SearchSpecHelper
  # rubocop:disable Metrics/MethodLength
  def process_user_results(results)
    res = []
    rec = {
      users: [],
      related: {
        tickets: []
      }
    }
    results.each do |result|
      rec[:users] = result[:users].to_h
      rec[:related][:tickets] = result[:related][:tickets].to_a.map(&:to_h)
      res.push(rec)
    end
    res
  end

  def process_ticket_results(results)
    res = []
    rec = {
      tickets: [],
      related: {
        users: []
      }
    }
    results.each do |result|
      rec[:tickets] = result[:tickets].to_h
      rec[:related][:users] = result[:related][:users].to_a.map(&:to_h)
      res.push(rec)
    end
    res
  end
  # rubocop:enable Metrics/MethodLength
end
