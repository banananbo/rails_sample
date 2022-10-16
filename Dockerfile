FROM ruby:2.6.6

# install tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        apt-transport-https \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
    && apt-get -y install yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install node 10.x
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs \
    && apt-get clean

# install bundler
RUN gem install bundler -v 2.2.33 --conservative

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install --with development
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]