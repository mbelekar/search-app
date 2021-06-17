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

    def options_h
      options = {}
      selected_options.each do |opt|
        key = opt.to_s.sub('@', '').sub('_list','').to_sym
        options[key] = instance_variable_get(opt)
      end
      options
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
