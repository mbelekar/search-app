# frozen_string_literal: true

require 'oj'

class JsonParser < Oj::ScHandler
  attr_reader :data

  def initialize
    super
    @data = []
  end

  def hash_start
    {}
  end

  def hash_set(h, k, v)
    h[k.to_sym] = v
  end

  def array_start
    []
  end

  def array_append(a, v)
    a << v
  end

  def add_value(v)
    @data << v
  end

  def error(message, line, column)
    puts "ERROR: #{message} at line #{line}, column #{column}"
  end

  def parse_file(filename)
    @data = []
    fh = File.open(filename, 'r')
    Oj.sc_parse(self, fh)
    fh.close
    @data.flatten!
  end
end
