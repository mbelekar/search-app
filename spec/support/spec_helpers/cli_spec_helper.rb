# frozen_string_literal: true

module CliSpecHelper
  # rubocop:disable Layout/HeredocIndentation
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

  def nil_opt_h_ticket
    {
      _id: nil,
      created_at: nil,
      type: nil,
      subject: nil,
      assignee_id: nil,
      tags: nil
    }
  end

  def nil_opt_h_user
    {
      _id: nil,
      name: nil,
      created_at: nil,
      verified: nil
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
        --verified       User Verified (Should be either true or false)
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
        --subject         Ticket Subject
        --assignee_id     Ticket Assignee Id (Should be a number)
        --tags            Ticket Tags (Supports searching multiple values at once)
        -h, --help        print help
    DOC
  end
  # rubocop:enable Layout/HeredocIndentation
end
