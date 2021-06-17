# frozen_string_literal: true

require 'clamp'

module CLI
  class BaseCommand < Clamp::Command
    # rubocop:disable Lint/DuplicateMethods
    attr_reader :selected_options

    def to_bool(s)
      case s
      when 'true', true then true
      when 'false', false then false
      else
        raise ArgumentError, "Invalid value for Boolean(): #{s}. Should be [true | false]"
      end
    end

    def any_option_selected?
      selected_options.count.positive?
    end

    def selected_options
      @selected_options ||= instance_variables.reject do |val|
        %i[@invocation_path @context @remaining_arguments].include?(val)
      end
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
