# frozen_string_literal: true

class Loader
  class InvalidFilePathError < StandardError; end

  attr_reader :data, :data_for_type, :config, :parser

  def initialize(config, parser)
    @data = {}
    @data_for_type = []
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
    @data_for_type = []
    files_list(path).each { |filename| load(filename) }
    @data[key] = @data_for_type
  end

  def load(filename)
    @parser.parse_file(filename)
    @data_for_type.push(*parser.data)
  end

  def files_list(path)
    Dir.glob("#{path}/*")
  end
end
