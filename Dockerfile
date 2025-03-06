ARG PHP_VERSION=8.1
ARG PHP_REDIS_VERSION=5.3.4

FROM php:${PHP_VERSION}-fpm-alpine

ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

RUN apk add --no-cache libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev libzip-dev oniguruma-dev libxml2-dev  postgresql-dev linux-headers \
        && docker-php-ext-install zip bcmath pdo_mysql pdo_pgsql mysqli mbstring opcache soap sockets \
        && docker-php-ext-configure gd \
		&& docker-php-ext-configure pcntl --enable-pcntl \
        && docker-php-ext-install gd pcntl

ENV PHP_REDIS_VERSION=${PHP_REDIS_VERSION}
RUN apk add --no-cache autoconf gcc g++ make linux-headers \
    && pecl install "redis-$PHP_REDIS_VERSION" \
    && docker-php-ext-enable redis \
    && apk del autoconf gcc g++ make

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data
WORKDIR /var/www/html