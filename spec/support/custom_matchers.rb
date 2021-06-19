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

RSpec::Matchers.define :load_files_for_type do |parser, file_path, **kwargs|
  match do |subject|
    begin
      type = kwargs[:type].to_sym
      files = Dir.glob("#{file_path}/*")

      files.each do |file|
        allow(parser).to receive(:parse_file).with(file)
      end

      allow(parser).to receive(:data).and_return(*kwargs[:stubbed_ret])

      subject.send(:load_files, type, file_path)
      expect(loader.data[type]).to eq(kwargs[:expected])
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

RSpec::Matchers.define :pass_file_to_parser do |klass, method, parser, file|
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