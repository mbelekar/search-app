# frozen_string_literal: true

require 'terminal-table'
require 'colorize'

module CLI
  module DataDisplay
    class NoResultsError < StandardError; end

    def data_display(type, data)
      msg = "Searching for #{type.capitalize} .."
      puts msg.cyan
      process_results(type, data)
    rescue NoResultsError => e
      display_message
    end

    private

    def process_results(type, data)
      raise NoResultsError if data.length.zero?

      @rows = []
      title = type.to_s.capitalize

      data.each do |d|
        append_search_results(d[type].to_h)
        related_results(d[:related])
      end
      render_table("#{title}:")
      @rows
    end

    def append_search_results(data)
      @rows << :separator
      data.each { |k, v| @rows << [k.to_s.red, format(v)] }
    end

    def related_results(data)
      data.each do |key, val|
        val = val.is_a?(Array) ? val : val.to_a
        val.each_with_index { |d, idx| append_related_results(key, idx, d.to_h) }
      end
    end

    def append_related_results(type, idx, data)
      type = type.to_s.chop
      allowed_attributes = %w[name subject]
      data.each do |k, v|
        key = display_key(type, idx, k)
        @rows << [key, format(v)] if allowed_attributes.include? k
      end
    end

    def display_key(type, idx, k)
      case type
      when 'ticket' then "#{type}_#{idx}".red
      when 'user' then "assignee_#{k.split('_').first}_#{idx}".red
      end
    end

    def format(arg)
      arg.is_a?(Array) ? arg.join(', ').to_s.red : arg.to_s.red
    end

    def table
      t = Terminal::Table.new
      t.headings = ['Attribute'.green, 'Value'.green]
      t.rows = @rows
      t.style.border.data = { x: '-'.cyan, y: '|'.cyan, i: '+'.cyan }
      t
    end

    def render_table(header)
      puts "\n"
      puts header.to_s.yellow
      puts table
    end

    def display_message
      puts "\n"
      puts 'No results found. Try using different search options ...'.red
    end
  end
end
