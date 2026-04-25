ARG PHP_VERSION=8.1

FROM php:${PHP_VERSION}-fpm-alpine

ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

RUN apk add --no-cache \
    imagemagick \
    imagemagick-dev \
    libtool \
    $PHPIZE_DEPS \
    fontconfig \
    ttf-dejavu \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    zlib-dev \
    libxpm-dev \
    oniguruma-dev \
    libxml2-dev  \
    postgresql-dev

RUN docker-php-ext-install zip bcmath pdo_mysql pdo_pgsql mysqli mbstring soap sockets \
        && docker-php-ext-configure gd \
		&& docker-php-ext-configure pcntl --enable-pcntl \
        && docker-php-ext-install gd pcntl \
        && if [ $(echo "$PHP_VERSION" | awk '{print ($1 <= 8.4)}') -eq 1 ]; then \
            docker-php-ext-install opcache; \
           fi

RUN wget https://github.com/php/pie/releases/latest/download/pie.phar && \
    chmod +x pie.phar && \
    mv pie.phar /usr/local/bin/pie

RUN pie install phpredis/phpredis && \
    pie install imagick/imagick

RUN apk del imagemagick-dev $PHPIZE_DEPS

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data
WORKDIR /var/www/html