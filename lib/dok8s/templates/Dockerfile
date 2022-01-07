FROM ruby:3.0.3
LABEL maintainer="admin@romanalmeida.com"

RUN apt-get install ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update -y && apt-get install -y \
  ca-certificates \
  libssl-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*
  
# Bundle the gems - doing it in tmp will make sure the layer is cached by Docker
COPY Gemfile* /tmp/
WORKDIR /tmp
ARG BUNDLE_WITHOUT
RUN bundle config set --local without ${BUNDLE_WITHOUT} && \
    gem install bundler && bundle install --jobs 5 --retry 5

ENV app /app
RUN mkdir $app
WORKDIR $app
ADD . $app

ARG RAILS_MASTER_KEY

RUN bundle exec rake assets:precompile RAILS_MASTER_KEY=${RAILS_MASTER_KEY} RAILS_ENV=production DATABASE_URL=postgresql://postgres@postgres:5432/not_in_use

# Run the app

VOLUME ["/app/public"]

RUN chmod -v +x /app/lib/* \
    && mv -v /app/lib/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
