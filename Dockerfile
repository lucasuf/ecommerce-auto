FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler -v 2.0.2
RUN bundle install
COPY . /myapp