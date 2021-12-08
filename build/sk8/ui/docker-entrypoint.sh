#!/bin/bash

set -e

export LOGGING_CONFIG="webapp/logback.xml"

if [[ ! -z "$SW_OAP_ADDRESS" ]]; then
  address_arr=(${SW_OAP_ADDRESS//,/ })
  for i in "${!address_arr[@]}"
  do
      JAVA_OPTS="${JAVA_OPTS} -Dspring.cloud.discovery.client.simple.instances.oap-service[$i].uri=${address_arr[$i]}"
  done
fi

# auth
JAVA_OPTS="${JAVA_OPTS} -Dspring.cloud.gateway.routes[1].id=auth"
JAVA_OPTS="${JAVA_OPTS} -Dspring.cloud.gateway.routes[1].uri=${AUTH_URI}"
JAVA_OPTS="${JAVA_OPTS} -Dspring.cloud.gateway.routes[1].predicates[0]=${AUTH_PATH}"

# exec java  ${JAVA_OPTS} -jar webapp/skywalking-webapp.jar "$@"
exec java   -Dspring.cloud.discovery.client.simple.instances.oap-service[1].uri=http://oap:1280 -Dspring.cloud.gateway.routes[1].uri=http://10.137.37.194:7777 -Dspring.cloud.gateway.routes[1].id=auth -Dspring.cloud.gateway.routes[1].predicates[0]=Path=/user/** -jar webapp/skywalking-webapp.jar "$@"
