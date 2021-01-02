FROM php:7.4-fpm-alpine

RUN apk add --no-cache libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev libzip-dev oniguruma-dev libxml2-dev \
        && docker-php-ext-install zip bcmath pdo_mysql mysqli mbstring opcache soap \
        && docker-php-ext-configure gd \
        && docker-php-ext-install gd

RUN apk add --no-cache autoconf gcc g++ make \
    && pecl install redis-5.1.1 \
    && docker-php-ext-enable redis \
    && apk del autoconf gcc g++ make

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN set -x; \
    addgroup -g 1000 -S www-data ; \
	adduser -G www-data -S www-data -u 1000
USER www-data
WORKDIR /var/www/html