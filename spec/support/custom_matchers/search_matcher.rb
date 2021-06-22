# frozen_string_literal: true

RSpec::Matchers.define :find_data_w_related_entity do |action, options, expected, helper_func|
  match do |subject|
    begin
      subject.method(action).call(options)
      actual = method(helper_func).call(subject.results)
      expect(actual).to eq(expected)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error = e
      raise
    end
  end

  failure_message do |_subject|
    <<~MESSAGE
      expected to find results but failed with error:
      #{@error}
    MESSAGE
  end
end
