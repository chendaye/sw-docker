# docker build --no-cache  --build-arg DIST=apache-skywalking-apm-bin.tar.gz --build-arg SKYWALKING_CLI_VERSION=0.7.0  -t skywalking/ui:latest  .

FROM adoptopenjdk/openjdk11:alpine-jre

ENV JAVA_OPTS=" -Xms256M " \
    SW_OAP_ADDRESS="http://oap:12800"
    # SW_OAP_ADDRESS="http://127.0.0.1:12800"


# RUN sed -i 's/https/http/' /etc/apk/repositories \
#     && apk add curl
WORKDIR skywalking

RUN set -ex; \
    apk add --no-cache \
    bash

ARG DIST=apache-skywalking-apm-bin.tar.gz
ARG SKYWALKING_CLI_VERSION
COPY "$DIST" .

RUN sed -i 's/https/http/' /etc/apk/repositories; \
    apk add curl; \
    tar -xzf "$DIST" --strip 1; \
    rm -rf "$DIST"; \
    rm -rf "config"; \
    rm -rf "bin"; \
    rm -rf "oap-libs"; \
    rm -rf "agent"; \
    rm -rf "webapp/webapp.yml"; \
    touch webapp/webapp.log;

COPY logback.xml webapp/
COPY webapp.yml webapp/
COPY docker-entrypoint.sh .


EXPOSE 8080

ENTRYPOINT ["bash", "docker-entrypoint.sh"]
