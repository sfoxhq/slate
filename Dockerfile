FROM ruby:2.5-alpine
WORKDIR /app

RUN apk add --no-cache make g++ gcc nodejs
COPY ["Gemfile", "Gemfile.lock", "/app/"]
RUN bundle install
COPY . .

EXPOSE 4567

CMD bundle exec middleman server
