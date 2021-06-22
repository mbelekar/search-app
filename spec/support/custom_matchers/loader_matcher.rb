# frozen_string_literal: true

RSpec::Matchers.define :invoke_parser_for_each_file do |parser, file_path, type|
  match do |subject|
    begin
      subject.call(type, file_path)
      files.each do |file|
        expect(parser).to have_received(:parse_file).with(file).once
      end
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error = e
      raise
    end
  end

  failure_message do |_subject|
    <<~MESSAGE
      expected loader to load all files from #{file_path} but failed with error:
      #{@error}
    MESSAGE
  end
end
