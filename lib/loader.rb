# frozen_string_literal: true

class Loader
  class InvalidFilePathError < StandardError; end

  attr_reader :data, :data_by_type, :config, :parser

  def initialize(config, parser)
    @data = {}
    @data_by_type = []
    @parser = parser
    @config = config
  end

  def call
    config.each do |key, path|
      raise InvalidFilePathError unless File.directory?(path)

      load_files(key, path)
    end
  end

  private

  def load_files(key, path)
    @data_by_type = []
    files_list(path).each { |filename| load(filename) }
    @data[key] = @data_by_type
  end

  def load(filename)
    @data_by_type.push(*@parser.parse_file(filename))
  end

  def files_list(path)
    Dir.glob("#{path}/*")
  end
end
