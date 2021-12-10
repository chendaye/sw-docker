# docker build --no-cache  --build-arg DIST=apache-skywalking-apm-bin.tar.gz --build-arg SKYWALKING_CLI_VERSION=0.7.0  -t skywalking/oap:latest  .

ARG BASE_IMAGE='adoptopenjdk/openjdk11:alpine'

# 构建 cli
FROM $BASE_IMAGE as cli

WORKDIR /skywalking

ARG SKYWALKING_CLI_VERSION=0.7.0
ENV SKYWALKING_CLI_TGZ=skywalking-cli-$SKYWALKING_CLI_VERSION-bin.tgz
ENV SKYWALKING_CLI_ASC=${SKYWALKING_CLI_TGZ}.asc
ENV SKYWALKING_CLI_SHA512=${SKYWALKING_CLI_TGZ}.sha512

ENV SKYWALKING_CLI_TGZ_URLS \
        https://www.apache.org/dyn/closer.cgi?action=download&filename=skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_TGZ \
        # if the version is outdated, we might have to pull from the dist/archive :/
	    https://www-us.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_TGZ \
	    https://www.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_TGZ \
	    https://archive.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_TGZ

ENV SKYWALKING_CLI_ASC_URLS \
        https://www.apache.org/dyn/closer.cgi?action=download&filename=skywalking/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_ASC \
        # if the version is outdated, we might have to pull from the dist/archive :/
	    https://www-us.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_ASC \
	    https://www.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_ASC \
	    https://archive.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_ASC

ENV SKYWALKING_CLI_SHA512_URLS \
        https://www.apache.org/dyn/closer.cgi?action=download&filename=skywalking/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_SHA512 \
        # if the version is outdated, we might have to pull from the dist/archive :/
	    https://www-us.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_SHA512 \
	    https://www.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_SHA512 \
	    https://archive.apache.org/dist/skywalking/cli/$SKYWALKING_CLI_VERSION/$SKYWALKING_CLI_SHA512


RUN set -eux; \
	\
	apk add --no-cache --virtual .fetch-deps \
		gnupg \
		ca-certificates \
		openssl \
	; \
	\
	wget --timeout=20 -O KEYS https://downloads.apache.org/skywalking/KEYS; \
	gpg --import KEYS; \
	\
	success=; \
	for url in $SKYWALKING_CLI_TGZ_URLS; do \
		if wget --timeout=20  -O ${SKYWALKING_CLI_TGZ} "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	success=; \
	for url in $SKYWALKING_CLI_SHA512_URLS; do \
		if wget --timeout=20  -O ${SKYWALKING_CLI_SHA512} "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	sha512sum -c ${SKYWALKING_CLI_SHA512}; \
	\
	success=; \
	for url in $SKYWALKING_CLI_ASC_URLS; do \
		if wget --timeout=20  -O ${SKYWALKING_CLI_ASC} "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	gpg --batch --verify ${SKYWALKING_CLI_ASC} ${SKYWALKING_CLI_TGZ}; \
	tar -xvf ${SKYWALKING_CLI_TGZ}; \
    mkdir "bin/"; \
	mv skywalking-cli-${SKYWALKING_CLI_VERSION}-bin/bin/swctl-${SKYWALKING_CLI_VERSION}-linux-amd64 bin/swctl; \
	chmod 755 bin/*; \
	command -v gpgconf && gpgconf --kill all || :; \
	ls -la .;

FROM $BASE_IMAGE

RUN sed -i 's/https/http/' /etc/apk/repositories; \
    apk add curl; \
	apk add --no-cache openssl

WORKDIR /skywalking

ENV JAVA_OPTS=" -Xms2G "

ARG DIST

COPY "$DIST" .

RUN set -ex; \
    tar -xzf "$DIST" --strip 1; \
    rm -rf "$DIST"; \
    rm -rf "config/log4j2.xml"; \
    rm -rf "bin"; \
    rm -rf "webapp"; \
    rm -rf "agent"; \
    mkdir "bin";

COPY --from=cli /skywalking/bin/swctl ./bin

COPY log4j2.xml config/
COPY docker-entrypoint.sh .

RUN mkdir ext-config; \
    mkdir ext-libs;

EXPOSE 12800 11800 1234

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
