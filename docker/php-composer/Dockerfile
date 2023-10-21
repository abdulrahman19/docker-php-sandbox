FROM sandbox/php-fpm:latest

ARG COMPOSER_VERSION=2.6.5

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# To be able to use composer inside the container
ENV PATH="${PATH}:/root/.composer/vendor/bin"

RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/bin/composer; chmod +x /usr/bin/composer

# Install global composer packages
RUN set -eux; \
  composer clear-cache;

WORKDIR /srv

# CMD ["composer"]
