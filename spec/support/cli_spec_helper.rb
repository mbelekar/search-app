# frozen_string_literal: true

module CliSpecHelper
  def opt_h_ticket
    {
      _id: 'sdfkhjf',
      created_at: '2021-05-21T09:30:00',
      type: 'foo',
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

  def users_help_output
    <<~DOC
    Usage:
        search users [OPTIONS]

    Options:
        --_id            User Id (Should be a number)
        --name           User Name
        --created_at     User Creation Timestamp
        --verified       User Verified (Should be eiher true or false)
        -h, --help       print help
    DOC
  end

  def tickets_help_output
    <<~DOC
    Usage:
        search tickets [OPTIONS]

    Options:
        --_id             Ticket Id
        --created_at      Ticket Creation Timestamp
        --type            Ticket Type
        --assignee_id     Ticket Assignee Id (Should be a number)
        --tags            Ticket Tags
        -h, --help        print help
    DOC
  end
end
