ARG PHP_VERSION=8.3
ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-alpine AS node
FROM composer:2 AS composer

FROM php:${PHP_VERSION}-cli-alpine

RUN apk add --no-cache \
        bash git openssh-client unzip curl \
        # Runtime libs (kept after build)
        libzip libpng libjpeg-turbo freetype libwebp \
        icu-libs gmp libldap libpq libxslt \
        libffi tidyhtml gettext-libs \
        imagemagick \
        libstdc++ \
        bzip2 \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev libwebp-dev \
        icu-dev gmp-dev openldap-dev postgresql-dev libxslt-dev \
        libffi-dev tidyhtml-dev imagemagick-dev \
        bzip2-dev gettext-dev \
    && docker-php-ext-configure gd \
        --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        bz2 \
        calendar \
        exif \
        ffi \
        gd \
        gettext \
        gmp \
        intl \
        ldap \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        tidy \
        xsl \
        zip \
    && pecl install apcu redis imagick \
    && docker-php-ext-enable apcu redis imagick \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/php/ext/*

COPY --from=node /usr/local/bin/node          /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules  /usr/local/lib/node_modules
RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN git config --system --add safe.directory '*' \
    && git config --system user.email "artifact-builder@localhost" \
    && git config --system user.name "Artifact Builder"

WORKDIR /app
