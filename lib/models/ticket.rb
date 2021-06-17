# frozen_string_literal: true

module Models
  class Ticket
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
        'assignee_id' => assignee_id
      }
    end
  end
end
