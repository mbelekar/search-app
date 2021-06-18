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

RSpec::Matchers.define :pass_each_file_from_config_to_parser do |config, parser, loader|
  match do |subject|
    begin
      keys = config.keys
      allow(config).to receive(:each).and_yield(keys[0], config[keys[0]])\
                                    .and_yield(keys[1], config[keys[1]])
      allow(parser).to receive(:parse_file).with("#{config[keys[0]]}/#{keys[0]}.json")
      allow(parser).to receive(:parse_file).with("#{config[keys[1]]}/#{keys[1]}.json")
      loader.call
      expect(parser).to have_received(:parse_file).with("#{config[keys[0]]}/#{keys[0]}.json")
      expect(parser).to have_received(:parse_file).with("#{config[keys[1]]}/#{keys[1]}.json")
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error = e
      raise
    end
  end

  failure_message do |subject|
    <<~MESSAGE
      expected loader to pass all files from config to the parser but failed with error:
      #{@error}
    MESSAGE
  end
end

RSpec::Matchers.define :pass_file_to_parser do |klass, method, parser, file|
  match do |subject|
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

  failure_message do |subject|
    <<~MESSAGE
      expected parser to pass file to #Oj.sc_parse but failed with error:
      #{@error}
    MESSAGE
  end
end