# frozen_string_literal: true

module ValidationSpecHelper
  def ticket_contr
    {
      _id: 'abc',
      created_at: '2021-05-21T10:30:00',
      type: 'foo',
      subject: 'bar',
      assignee_id: 111,
      tags: %w[baz qux]
    }
  end

  def incorrect_ticket_contr
    {
      _id: 100,
      created_at: '2021-05-21T10:30:00',
      status: 'closed',
      subject: 'bar',
      assignee_id: 111,
      tags: %w[baz qux]
    }
  end

  def user_contr
    {
      _id: 100,
      name: 'foo',
      created_at: '2021-05-21T10:30:00',
      verified: true
    }
  end

  def incorrect_user_contr
    {
      _id: 'abc',
      name: 123,
      created_at: '2021-05-21T10:30:00',
      verified: 345
    }
  end

  def nil_values_user_contr
    {
      _id: nil,
      name: nil,
      created_at: nil,
      verified: nil
    }
  end

  def empty_values_user_contr
    {
      _id: 1,
      name: nil,
      created_at: nil,
      verified: false
    }
  end

  def nil_values_ticket_contr
    {
      _id: nil,
      created_at: nil,
      type: nil,
      subject: nil,
      assignee_id: nil,
      tags: nil
    }
  end

  def empty_values_ticket_contr
    {
      _id: '',
      created_at: '',
      type: '',
      subject: '',
      assignee_id: 111,
      tags: []
    }
  end
end
