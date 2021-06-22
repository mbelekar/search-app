# frozen_string_literal: true

require './lib/factories/model_factory'
require './lib/factories/validation_factory'

class Transformer
  class InvalidArgError < StandardError; end

  attr_reader :contract, :model, :type

  def initialize(type)
    raise InvalidArgError if type.nil?

    @type = type.to_sym
    @contract = Factories::ValidationFactory.for(@type).new
    @model = Factories::ModelFactory.for(@type)
  end

  def call(data)
    raise InvalidArgError unless data.is_a? Array

    data.map do |d|
      v_data = @contract.validate(d)
      @model.new(v_data)
    end
  end
end
