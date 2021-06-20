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

  def hash_to_model(data, model)
    data.map { |d| model.new(d) }
  end

  def model_to_h(data)
    data.map(&:to_h)
  end

  class MockUser
    attr_reader :_id, :name, :created_at, :verified

    def initialize(args)
      @_id = args[:_id]
      @name = args[:name]
      @created_at = args[:created_at]
      @verified = args[:verified]
    end

    def to_h
      {
        '_id' => _id,
        'name' => name,
        'created_at' => created_at,
        'verified' => verified
      }
    end
  end

  class MockTicket
    attr_reader :_id, :created_at, :type, :subject, :assignee_id, :tags

    def initialize(args)
      @_id = args[:_id]
      @created_at = args[:created_at]
      @type = args[:type]
      @subject = args[:subject]
      @assignee_id = args[:assignee_id]
      @tags = args[:tags]
    end

    def to_h
      {
        '_id' => _id,
        'created_at' => created_at,
        'type' => type,
        'subject' => subject,
        'assignee_id' => assignee_id,
        'tags' => tags
      }
    end
  end
end
