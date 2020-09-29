FROM php:7.4-fpm

# Install the PHP extensions we need

RUN apt-get clean -y \
apt-get update && \
apt-get install -y --no-install-recommends \
    curl \
    git \
    mariadb-client-10.3 \
    libmemcached-dev \
    libz-dev \
    libzip-dev \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libmemcached-dev \
    libmcrypt-dev \
    zlib1g-dev && \
    docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli opcache intl bcmath zip sockets && \
    pecl install mcrypt-1.0.3 && \
    docker-php-ext-enable bcmath zip pdo_mysql mcrypt sockets

# install memcached, xdebug, redis
RUN pecl install memcached xdebug redis

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# config china mirror
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

VOLUME /app/web
WORKDIR /app/web