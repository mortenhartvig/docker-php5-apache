FROM php:7.1.11-apache

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
                mysql-client \
                wget \
                unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        iconv \
        intl \
        mcrypt \
        opcache \
        pdo \
        mysqli \
        pdo_mysql \
        mbstring \
        soap \
        gd \
        zip \
        pcntl 

# Install Xdebug
RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.5.5.tgz' -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && ( \
    	cd xdebug \
    	&& phpize \
    	&& ./configure --enable-xdebug \
    	&& make -j$(nproc) \
    	&& make install \
    ) \
    && rm -r xdebug \
    && docker-php-ext-enable xdebug

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=AT/ST$


# Apache configuration
RUN a2ensite default-ssl
RUN a2enmod ssl
RUN a2enmod rewrite

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/

VOLUME /var/www/html/
EXPOSE 80
EXPOSE 443
CMD ["apache2-foreground"]
