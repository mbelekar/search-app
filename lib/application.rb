# frozen_string_literal: true

require 'yaml'
require './lib/cli/main_command'
require './lib/parser'

class Application
  # rubocop:disable Lint/DuplicateMethods
  attr_reader :tickets, :users, :config, :parser, :data

  def initialize
    @parser = Parser.new
  end

  def run(_type, *_kwargs)
    config.each do |key, path|
      parse_files(path)
      instance_variable_set("@#{key}", @data)
    end
  end

  private

  def parse_files(path)
    @data = []
    files = Dir.glob("#{path}/*")

    files.each do |filename|
      File.open(filename, 'r') do |fh|
        @data.push(*@parser.parse_file(fh))
      end
    end
  end

  def config
    @config ||= YAML.safe_load(File.read('./config/files.yml'))['path']
  end
  # rubocop:enable Lint/DuplicateMethods
end
