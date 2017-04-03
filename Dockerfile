FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y firefox ruby xvfb unzip ruby-dev build-essential zlib1g-dev wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget 'https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-linux64.tar.gz' \
  ; tar -xzf geckodriver-v0.15.0-linux64.tar.gz \
  ; mv geckodriver /usr/bin/geckodriver \
  ; chmod a+x /usr/bin/geckodriver

RUN mkdir /app
RUN mkdir /download

WORKDIR /app
COPY . /app

RUN gem install bundler
RUN bundle install

ENTRYPOINT [ "/app/entrypoint.sh" ]
