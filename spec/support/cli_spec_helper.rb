# frozen_string_literal: true

module CliSpecHelper
  def opt_h_ticket
    {
      _id: 'sdfkhjf',
      created_at: '2021-05-21T09:30:00',
      type: 'foo',
      subject: 'bar',
      assignee_id: 1,
      tags: %w[baz qux]
    }
  end

  def opt_h_user
    {
      _id: 1,
      name: 'foo',
      created_at: '2021-05-21T09:30:00',
      verified: true
    }
  end

  def incorrect_opt_h_user
    {
      _id: 'abc',
      verified: 'def'
    }
  end
end
