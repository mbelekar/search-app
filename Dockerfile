FROM ruby:3.0.1

WORKDIR /app

COPY bin /app/bin
COPY config /app/config
COPY data /app/data
COPY lib /app/lib
COPY spec /app/spec
COPY README.md /app/
COPY Rakefile /app/
COPY Gemfile /app/
COPY Gemfile.lock /app/

ENV PATH="/app/bin:${PATH}"

RUN bundle config without development
RUN bundle install

CMD ["/bin/bash"]