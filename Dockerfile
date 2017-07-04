FROM php:7.1.6-apache

MAINTAINER Morten Hartvig <hartvigmorten@gmail.com>

# Avoid questions during installation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -y libmcrypt-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libfreetype6-dev \
		libxml2-dev \
		libicu-dev \
		mysqli-client \
		wget \
		unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install iconv intl mcrypt opcache pdo mysqli pdo_mysql mbstring soap gd zip

# Apache configuration
RUN a2enmod rewrite

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/

VOLUME /var/www/html/
EXPOSE 80
CMD ["apache2-foreground"]
