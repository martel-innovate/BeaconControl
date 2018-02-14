FROM ubuntu

RUN apt-get -y update
RUN apt-get -y install build-essential zlib1g-dev libssl-dev \
    libyaml-dev wget openssl git libreadline-dev libgdbm-dev libmysqlclient-dev \
    wget libpq-dev libpq5 libpqxx-4.0 mysql-client \
    libpqxx-dev memcached nodejs nodejs-dev redis-server libxml2 libsasl2-2 \
    libxslt-dev libxml2-dev libgmp-dev libgmp3-dev libgmp10 libmysql++-dev \
    libmysqlclient-dev libmysqld-dev librtmp-dev \
    postgresql-client postgresql-client-common git

RUN cd /tmp && \
    wget http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.4.tar.gz && \
    tar -xvzf ruby-2.2.4.tar.gz && \
    cd ruby-2.2.4/ && \
    ./configure --with-openssl-dir=/usr/bin && \
    make && \
    make install

ADD . /app
WORKDIR /app

RUN cd /app && gem install bundler && bundle install

ENTRYPOINT rails s -b 0.0.0.0
