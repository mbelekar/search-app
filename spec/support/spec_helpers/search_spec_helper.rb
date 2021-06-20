# frozen_string_literal: true

module SearchSpecHelper
  # rubocop:disable Metrics/MethodLength
  def process_user_results(results)
    res = []

    results.each do |result|
      rec = {
        users: result[:users].to_h,
        related: {
          tickets: result[:related][:tickets].to_a.map(&:to_h)
        }
      }
      res.push(rec)
    end
    res
  end

  def process_ticket_results(results)
    res = []

    results.each do |result|
      rec = {
        tickets: result[:tickets].to_h,
        related: {
          users: result[:related][:users].to_a.map(&:to_h)
        }
      }
      res.push(rec)
    end
    res
  end
  # rubocop:enable Metrics/MethodLength
end
