# frozen_string_literal: true

module CLI
  class UserCommand < BaseCommand
    option '--_id', '', 'User Id (Should be a number)' do |s|
      Integer(s)
    end
    option '--name', '', 'User Name'
    option '--created_at', '', 'User Creation Timestamp'
    option '--verified', '', 'User Verified (Should be eiher true or false)' do |s|
      to_bool(s)
    end

    def execute
    end
  end
end