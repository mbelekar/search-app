FROM ruby:3.0.1-alpine@sha256:4d36ec22d6114942127fc06cf602201e598ab423a09d0edecd22e9071160f2a0

WORKDIR /app

COPY bin /app/bin
COPY lib /app/lib
COPY data /app/data
COPY spec /app/spec
COPY README.md /app/
COPY Rakefile /app/
COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle install

WORKDIR /cwd
ENTRYPOINT ["./bin/search"]