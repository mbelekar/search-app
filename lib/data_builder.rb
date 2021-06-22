# frozen_string_literal: true

require './lib/transformer'
require './lib/loader'

class DataBuilder
  class InvalidFilePathError < StandardError; end

  class InvalidConfigKeyError < StandardError; end

  attr_accessor :config
  attr_reader :transformer, :loader, :data

  def initialize(config, loader, transformer)
    raise InvalidConfigKeyError if config['type'].nil?
    raise InvalidConfigKeyError if config['path'].nil? || config['path'].empty?

    @config = config
    @loader = loader
    @transformer_klass = transformer
    @data = {}
  end

  def run
    @config['path'].each do |key, path|
      raise InvalidFilePathError unless File.directory?(path)

      raw_data = load_data(key, path)
      build_data(raw_data, key)
    end
    @data
  end

  private

  def load_data(key, path)
    @loader.call(key, path)
  end

  def build_data(raw_data, key)
    transformer = @transformer_klass.new(key)
    @data[key] = transformer.call(raw_data)
  end
end
