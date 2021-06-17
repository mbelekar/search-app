# frozen_string_literal: true

module Models
  class User
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
end
