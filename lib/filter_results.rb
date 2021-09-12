# frozen_string_literal: true

module FilterResults
  attr_reader :results

  private
  
  def search_record(arr, key, value)
    arr.lazy.select do |a|
      actual = a.method(key).call
      a if actual.is_a?(Array) && actual.include?(value) || actual == value
    end
  end
  
  def filter(arr, options)
    results = []
    options.each do |k, v|
      if v.is_a? Array
        v.each { |val| results << search_record(arr, k, val)}
      else
        results << search_record(arr, k, v)
      end
    end
    results
  end
end
