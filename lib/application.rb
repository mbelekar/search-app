# frozen_string_literal: true

require 'yaml'
require './lib/configure'
require './lib/factories/search_factory'

class Application
  attr_accessor :config
  attr_reader :search_class, :configure

  def initialize(type, config=nil)
    @configure = Configure.new(config)
    @search_class = Factories::SearchFactory.for(type)
  end

  def run(kwargs)
    data = @configure.run
    search = @search_class.new(data)
    results = search.run(kwargs)
    results
  end

  private

  def config
    @config ||= YAML.safe_load(File.read('./config/files.yml'))
  end

end
