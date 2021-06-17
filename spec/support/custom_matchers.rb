# frozen_string_literal: true

RSpec::Matchers.define :invoke_subcommand do |klass, cmd|
  match do |subject|
    begin
      mock = instance_double(klass)
      allow(klass).to receive(:new).and_return(mock)

      allow(mock).to receive(:run).and_return(true)
      subject.run([cmd.to_s])

      expect(mock).to have_received(:run).once
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error = e
      raise
    end
  end

  failure_message do |subject|
    <<~MESSAGE
      expected #{subject.class} to invoke subcommand #{klass} when called with #{cmd} but failed with error:
      #{@error}
    MESSAGE
  end
end