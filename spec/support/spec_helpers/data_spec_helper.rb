# frozen_string_literal: true

module DataSpecHelper
  # rubocop:disable Metrics/MethodLength
  def user_data
    [
      {
        _id: 1,
        name: 'foo',
        created_at: '2016-04-15T05:19:46-10:00',
        verified: true
      },
      {
        _id: 2,
        name: 'bar',
        created_at: '2016-06-23T10:31:39-10:00',
        verified: true
      }
    ]
  end

  def user_data_a
    [
      {
        _id: 3,
        name: '',
        created_at: '2016-04-15T05:19:46-10:00',
        verified: false
      },
      {
        _id: 4,
        name: 'qux',
        created_at: '2016-06-23T10:31:39-10:00',
        verified: false
      },
      {
        _id: nil,
        name: 'qux',
        created_at: '2016-06-23T10:31:39-10:00',
        verified: false
      },
      {
        _id: 6,
        name: 'quux',
        created_at: '2016-06-23T10:31:39-10:00',
        verified: nil
      }
    ]
  end

  def ticket_data
    [
      {
        _id: '545-fhj-87hg8',
        created_at: '2016-04-28T11:19:34-10:00',
        type: 'incident',
        subject: 'foo',
        assignee_id: 1,
        tags: %w[bar baz qux]
      },
      {
        _id: '34357-fh7gy77',
        created_at: '2016-04-14T08:32:31-10:00',
        type: 'foo',
        subject: 'bar',
        assignee_id: 2,
        tags: %w[bar baz qux quux]
      }
    ]
  end

  def ticket_data_a
    [
      {
        _id: '38746dfg-tth-lk23',
        created_at: '2016-04-28T11:19:34-10:00',
        type: 'quux',
        subject: '',
        assignee_id: 3,
        tags: %w[quux quuz qux]
      },
      {
        _id: '294jgf-3wrii-45ng',
        created_at: '2016-04-14T08:32:31-10:00',
        type: 'waldo',
        subject: 'fred',
        assignee_id: 4,
        tags: %w[quux quuz qux waldo]
      },
      {
        _id: 'hgh98-6ggf7-iu',
        created_at: '2016-04-14T08:32:31-10:00',
        type: 'foo',
        subject: 'test',
        assignee_id: nil,
        tags: []
      }
    ]
  end

  def parsed_files_data_u
    user_data.concat(user_data_a)
  end

  def parsed_files_data_t
    ticket_data.concat(ticket_data_a)
  end

  def parsed_files_data
    {
      'users' => user_data_a.concat(user_data),
      'tickets' => ticket_data_a.concat(ticket_data)
    }
  end
  # rubocop:enable Metrics/MethodLength
end
