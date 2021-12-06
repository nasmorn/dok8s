FROM ruby:3.0.2
LABEL maintainer="admin@romanalmeida.com"

RUN apt-get install ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update -y && apt-get install -y \
  ca-certificates \
  libssl-dev \
  nodejs
  
ARG BUNDLE_WITHOUT

# Bundle the gems - doing it in tmp will make sure the layer is cached by Docker
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN gem install bundler && bundle install --jobs 20 --retry 5 ${BUNDLE_WITHOUT}

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
