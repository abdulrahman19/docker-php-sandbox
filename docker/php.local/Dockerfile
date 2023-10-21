FROM sandbox/php-composer:latest

# Install xdebug
ARG INSTALL_XDEBUG=0
ARG XDEBUG_VERSION=3.2.2

RUN if [ "$INSTALL_XDEBUG" = 1 ]; then \
    set -eux; \
	pecl install xdebug-${XDEBUG_VERSION}; \
	docker-php-ext-enable xdebug; \
fi

# Install additional PHP packages
RUN set -eux; \
    pecl install -o -f redis; \
    docker-php-ext-enable redis;

# Clear before leaving :)
ARG CLEAR_DEPS=0

RUN if [ "$CLEAR_DEPS" = 1 ]; then \
    apk del .build-deps; \
fi

COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php.ini php-cli.ini /usr/local/etc/php/

# To be able to use composer/yarn inside the container
ENV PATH="${PATH}:/root/.composer/vendor/bin"

WORKDIR /srv

CMD ["php-fpm"]
