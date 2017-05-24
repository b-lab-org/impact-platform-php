FROM php:5.6-alpine
MAINTAINER "The Impact Bot" <technology@bcorporation.net>

RUN set -xe; \
    apk add --no-cache \
    libmemcached-dev \
    libmcrypt-dev \
    autoconf \
    g++ \
    make \
    postgresql-dev \
    cyrus-sasl-dev \
    build-base \
    readline-dev \
    openssl-dev \
    zlib-dev \
    libxml2-dev \
    glib-lang \
    wget \
    gnupg \
    ncurses \
    ca-certificates \
    libssl1.0 && \
    
    # this version of alpine has postgresql 9.5 by default
    # TODO remove this dependency in the future
    wget ftp://ftp.postgresql.org/pub/source/v9.4.11/postgresql-9.4.11.tar.bz2 -O /tmp/postgresql-9.4.11.tar.bz2 && \
    tar xvfj /tmp/postgresql-9.4.11.tar.bz2 -C /tmp && \
    cd /tmp/postgresql-9.4.11 && ./configure --enable-integer-datetimes --enable-thread-safety --prefix=/usr/local --with-libedit-preferred --with-openssl  && make world && make install world && make -C contrib install && \
    cd /tmp/postgresql-9.4.11/contrib && make && make install && \
    apk --purge del build-base wget gnupg ca-certificates && \
    rm -r /tmp/postgresql-9.4.11* && \

    # php extensions
    docker-php-ext-install \
    json \
    mcrypt \
    pdo \
    opcache \
    pcntl \
    pdo_pgsql && \

    pecl install \
    xdebug \
    memcached-2.2.0 && \

    docker-php-ext-enable xdebug memcached opcache pcntl && \

    # cleanup
    apk del \
    autoconf \
    g++ \
    make \
    cyrus-sasl-dev \
    readline-dev \
    openssl-dev \
    zlib-dev \
    libxml2-dev && \
    rm -rf /var/cache/apk/* && \
    docker-php-source delete && \
    rm -rf /tmp/*

RUN mkdir -p /data/www
VOLUME ["/data"]
WORKDIR /data/www

ADD php.ini $PHP_INI_DIR/conf.d/impact.ini
ENTRYPOINT ["php"]
CMD ["--help"]
