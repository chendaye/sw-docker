FROM centos:7.5.1804
LABEL maintainer="chendaye666@gmail.com"

# set environment
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk" \
    JAVA="/usr/lib/jvm/java-1.8.0-openjdk/bin/java" \
    JVM_XMS="1g" \
    JVM_XMX="1g" \
    JVM_XMN="512m" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    JAVA_OPTS=" -Xms256M " \
    TIME_ZONE="Asia/Shanghai"

# 环境变量=默认值
ARG SK_VERSION=8.8.1

# work dir
WORKDIR /opt/apache-skywalking-apm-bin

# install java
RUN set -x \
    && yum update -y \
    && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget iputils nc  vim libcurl

# install skywalking
COPY ./apache-skywalking-apm-bin.tar.gz /opt/
RUN set -eux \
    && tar -zxvf /opt/apache-skywalking-apm-bin.tar.gz -C /opt/ \
    && rm -rf webapp \
    && rm -rf agent

# copy 配置以及启动文件
RUN mkdir ext-config; \
    mkdir ext-libs;
# COPY application.yml ext-config/
COPY log4j2.xml config/
COPY docker-entrypoint.sh .


# delect cache
RUN yum autoremove -y wget \
    &&  echo $TIME_ZONE > /etc/timezone \
    && yum clean all



EXPOSE 12800 11800 1234
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
