ARG PHP_VERSION=8.2.11

FROM php:${PHP_VERSION}-fpm-alpine

# update all existing alpine os packages
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
RUN apk update

# persistent / runtime deps
RUN apk add --update --no-cache linux-headers \
    acl \
    file \
    gettext \
    git \
    make \
    fcgi \
    gnu-libiconv \
;

# install gnu-libiconv and set LD_PRELOAD env to make iconv work fully on Alpine image.
# see https://github.com/docker-library/php/issues/240#issuecomment-763112749
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

# install php extensions
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        coreutils \
        icu-dev \
        libzip-dev \
        zlib-dev \
        libtool \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
;

RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype; \
    docker-php-ext-configure zip; \
    docker-php-ext-install -j$(nproc) \
        exif \
        gd \
        intl \
        pdo_mysql \
        zip \
        sockets \
        bcmath \
;

ARG APCU_VERSION=5.1.22

RUN pecl install apcu-${APCU_VERSION}; \
	pecl clear-cache; \
	docker-php-ext-enable apcu opcache sockets; \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .phpexts-rundeps $runDeps;

# Clear before leaving :)
ARG CLEAR_DEPS=0

RUN if [ "$CLEAR_DEPS" = 1 ]; then \
    apk del .build-deps; \
fi

# docker healthcheck
COPY docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

# php.ini
COPY php-cli.ini /usr/local/etc/php/php-cli.ini

WORKDIR /srv

CMD ["php-fpm"]
