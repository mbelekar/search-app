# frozen_string_literal: true

require './lib//builder'
require './lib/loader'
require './lib/factories/parser_factory'

class Configure
  class InvalidFilePathError < StandardError; end

  attr_accessor :config
  attr_reader :builder, :loader, :data

  def initialize
    file_type = config['type'].to_sym
    @parser = Factories::ParserFactory.for(file_type).new
    @loader = Loader.new(config, @parser)
    @data = {}
  end

  def run
    @config['path'].each do |key, path|
      raw_data = load_data(key, path)
      build_data(raw_data, key)
    end
    @data
  end

  private

  def config
    @config ||= YAML.safe_load(File.read('./config/files.yml'))
  end

  def load_data(key, path)
    raise InvalidFilePathError unless File.directory?(path)

    @loader.call(key, path)
  end

  def build_data(raw_data, key)
    @builder = Builder.new(key)
    @data[key] = @builder.call(raw_data)
  end
end
