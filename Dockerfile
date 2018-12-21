FROM ruby:2.5.3-slim

MAINTAINER Axel Kelting <axel@kelting.cc>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - libpq-dev: Communicate with postgres through the postgres gem
RUN apt-get update
RUN apt-get install -qq -y build-essential libpq-dev file git-core --fix-missing --no-install-recommends
RUN apt-get install -qq -y git-core --fix-missing --no-install-recommends

ENV BUNDLE_PATH /bundles
ENV BUNDLE_JOBS=2
ENV GEM_HOME=/bundles

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
