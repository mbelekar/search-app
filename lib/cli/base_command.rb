# frozen_string_literal: true

require 'clamp'

module CLI
  class BaseCommand < Clamp::Command
    def to_bool(s)
      case s
      when 'true' then true
      when 'false' then false
      else
        raise ArgumentError, "Invalid value for Boolean(): #{s}. Should be [true | false]"
      end
    end
  end
end