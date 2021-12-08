#!/bin/bash

set -e

echo "[Entrypoint] Apache SkyWalking Docker Image"

EXT_LIB_DIR=/opt/apache-skywalking-apm-bin/ext-libs
EXT_CONFIG_DIR=/opt/apache-skywalking-apm-bin/ext-config

# 覆盖配置文件
cp -vfR ${EXT_CONFIG_DIR}/* config/ || true
CLASSPATH="config:$CLASSPATH"

# 依赖的jar 包
for i in oap-libs/*.jar
do
    CLASSPATH="$i:$CLASSPATH"
done
for i in ${EXT_LIB_DIR}/*.jar
do
    CLASSPATH="$i:$CLASSPATH"
done

echo "Configuration files:"
ls -lt /opt/apache-skywalking-apm-bin/config

# 启动 oap
set -ex
exec java ${JAVA_OPTS} -classpath ${CLASSPATH} org.apache.skywalking.oap.server.starter.OAPServerStartUp "$@" # "$@" 表示传递的所有参数 
