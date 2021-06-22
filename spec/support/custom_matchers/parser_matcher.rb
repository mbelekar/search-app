# frozen_string_literal: true

RSpec::Matchers.define :invoke_sc_parse do |klass, method, parser, file|
  match do |_subject|
    begin
      allow(File).to receive(:open).with(file, 'r').and_return(fh)
      allow(fh).to receive(:close)
      allow(klass).to receive(method).with(parser, fh)
      parser.parse_file(file)
      expect(klass).to have_received(method).with(parser, fh).once
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error = e
      raise
    end
  end

  failure_message do |_subject|
    <<~MESSAGE
      expected parser to pass file to #Oj.sc_parse but failed with error:
      #{@error}
    MESSAGE
  end
end
