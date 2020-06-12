FROM ruby:2.7.1
LABEL maintainer="kent@slaymakercellars.com"

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  nodejs \
  postgresql-client

ENV BUNDLE_PATH /gems
ENV PATH $BUNDLE_PATH/bin:$GEM_HOME/gems/bin:$PATH

WORKDIR /app
EXPOSE 3000

RUN gem install bundler

ENTRYPOINT [ "./script/docker-entrypoint.sh" ]
