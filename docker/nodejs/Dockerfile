ARG NODE_VERSION=19.0.0

FROM node:${NODE_VERSION}-alpine

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		g++ \
		gcc \
		git \
		make \
		python3 \
	;

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /srv

ENTRYPOINT ["docker-entrypoint"]
CMD ["yarn"]
