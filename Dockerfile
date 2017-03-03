FROM ubuntu:16.04

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp

# See : https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN echo "deb http://packages.erlang-solutions.com/ubuntu trusty contrib" >> /etc/apt/sources.list && \
    apt-key adv --fetch-keys http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
    apt-get -qq update && apt-get install -y \
    build-essential \
    curl \
    esl-erlang \
    git \
    git-core \
    libcurl4-openssl-dev \
    libffi-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    openssh-server \
    python-software-properties \
    sqlite3 \
    unzip \
    wget \
    zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and Install Specific Version of Elixir
RUN mkdir /opt/elixir
WORKDIR /opt/elixir
RUN wget -q https://github.com/elixir-lang/elixir/releases/download/v1.3.2/Precompiled.zip && \
    unzip Precompiled.zip && \
    rm -f Precompiled.zip && \
    ln -s /opt/elixir/bin/elixirc /usr/local/bin/elixirc && \
    ln -s /opt/elixir/bin/elixir /usr/local/bin/elixir && \
    ln -s /opt//elixir/bin/mix /usr/local/bin/mix && \
    ln -s /opt/elixir/bin/iex /usr/local/bin/iex

# Install local Elixir hex and rebar
RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force && \
    /usr/local/bin/mix hex.info

# Install local Ruby 2.2.3
RUN mkdir -p /opt/ruby
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build
RUN /opt/ruby-build/bin/ruby-build 2.2.3 /opt/ruby/2.2.3
RUN /opt/ruby/2.2.3/bin/gem install bundler fpm --no-ri --no-rdoc
RUN /opt/ruby/2.2.3/bin/fpm -s dir -t deb -n ruby-2.2.3 -v 1.0.0 /opt/ruby/2.2.3


WORKDIR /
