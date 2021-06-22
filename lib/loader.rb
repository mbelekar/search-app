# frozen_string_literal: true

require './lib/factories/parser_factory'

class Loader
  class InvalidArgError < StandardError; end

  attr_reader :data, :data_for_type, :config, :parser

  def initialize(config, parser)
    @data = {}
    @data_for_type = []
    @parser = parser
    @config = config
  end

  def call(key, path)
    @data_for_type = []
    files_list(path).each { |filename| load(filename) }
    @data[key] = @data_for_type
  end

  private

  def load(filename)
    data = @parser.parse_file(filename)
    @data_for_type.push(*data.flatten!)
  end

  def files_list(path)
    Dir.glob("#{path}/*")
  end
end
