# frozen_string_literal: true

require 'json'
require './lib/data_builder'
require './lib/factories/search_factory'
require './lib/cli/data_display'

class Application
  class InvalidSearchTypeError < StandardError; end

  class InvalidSearchOptionError < StandardError; end

  include CLI::DataDisplay

  attr_reader :builder, :type
  attr_accessor :search_class

  def initialize(type, config = default)
    raise InvalidSearchTypeError unless valid?(type)

    @type = type
    file_type = config['type'].to_sym
    @builder = DataBuilder.new(
      config,
      Loader.new(config, Factories::ParserFactory.for(file_type).new),
      Transformer
    )
    @search_class = Factories::SearchFactory.for(@type)
  end

  def run(kwargs)
    raise InvalidSearchOptionError if kwargs.empty? || kwargs.nil?

    data = @builder.run
    search = @search_class.new(data)
    results = search.run(kwargs)
    data_display(@type, results)
    results
  end

  private

  def valid?(type)
    %i[users tickets].include? type
  end

  def default
    JSON.parse(File.read('./config/data_files.json'))
  end
end
