# frozen_string_literal: true

module ModelSpecHelper
  def user_h
    {
      _id: 1,
      name: 'foo',
      created_at: '2021-05-31T11:00:00',
      verified: true
    }
  end

  def ticket_h
    {
      _id: 'ydfjf',
      created_at: '2021-05-31T11:00:00',
      type: 'email',
      subject: 'foo',
      assignee_id: 111,
      tags: %w[baz qux]
    }
  end

  def model_data(data, model)
    data.map { |d| model.new(d) }
  end
end