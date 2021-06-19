# frozen_string_literal: true

require './lib/factories/model_factory'
require './lib/factories/validation_factory'

class Builder
  attr_reader :contract, :model, :type

  def initialize(type)
    @type = type.to_sym
    @contract = Factories::ValidationFactory.for(@type).new
    @model = Factories::ModelFactory.for(@type)
  end

  def call(data)
    data.map do |d|
      v_data = @contract.validate(d)
      @model.new(v_data) unless v_data.nil?
    end
  end
end
