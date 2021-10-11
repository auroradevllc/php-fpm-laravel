FROM php:8.0-fpm-alpine

RUN apk add --no-cache libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev libzip-dev oniguruma-dev libxml2-dev postgresql-dev \
        && docker-php-ext-install zip bcmath pdo_mysql pdo_pgsql mysqli mbstring opcache soap sockets \
        && docker-php-ext-configure gd \
        && docker-php-ext-install gd

RUN apk add --no-cache autoconf gcc g++ make \
    && pecl install redis-5.3.4 \
    && docker-php-ext-enable redis \
    && apk del autoconf gcc g++ make

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data
WORKDIR /var/www/html