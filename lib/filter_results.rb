# frozen_string_literal: true

module FilterResults
  attr_reader :results

  private

  def select_criteria(record, options)
    sel = []
    options.each do |k, v|
      value = record.method(k).call
      sel << if v.is_a? Array
               included?(value, v)
             else
               (value == v)
             end
    end
    sel
  end

  def included?(actual, opt_values)
    sel = []
    opt_values.each do |val|
      sel << actual.include?(val)
    end
    !sel.include?(false)
  end

  def filter(arr, options)
    arr.lazy.select { |a| a unless select_criteria(a, options).any?(false) }
  end
end
