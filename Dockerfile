FROM ruby:2.5-alpine
ENV APP /app
ENV BUILD /build

RUN apk update \
    && apk add ruby-dev make g++ nodejs

RUN mkdir $APP
RUN mkdir $BUILD


WORKDIR $BUILD
RUN gem install execjs
RUN gem install fast_blank -v "1.0.0" --source "https://rubygems.org"

WORKDIR $APP
ADD . .
RUN bundle install
CMD bundle exec middleman server