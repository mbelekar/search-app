require './lib/factories/builder_factory'
require './lib/factories/loader_factory'
require './lib/factories/parser_factory'

class Configure
  class InvalidFilePathError < StandardError; end

  attr_accessor :config
  attr_reader :builder, :loader, :data

  def initialize
    @file_type = config["type"].to_sym
    @parser = Factories::ParserFactory.for(@file_type).new
    @loader = Factories::LoaderFactory.for(@file_type).new(config, @parser)
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
    @builder = Factories::BuilderFactory.for(@file_type).new(key)
    @data[key] = @builder.call(raw_data)
  end
end