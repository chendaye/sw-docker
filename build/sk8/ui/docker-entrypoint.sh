#!/bin/bash

set -e

export LOGGING_CONFIG="webapp/logback.xml"
export WEBAPP_CONFIG="webapp/webapp.yml"
export LOG_FILE_LOCATION="webapp/webapp.log"

if [[ ! -z "$SW_OAP_ADDRESS" ]]; then
  address_arr=(${SW_OAP_ADDRESS//,/ })
  for i in "${!address_arr[@]}"
  do
      JAVA_OPTS="${JAVA_OPTS} -Dspring.cloud.discovery.client.simple.instances.oap-service[$i].uri=${address_arr[$i]}"
  done
fi



exec java  ${JAVA_OPTS} -jar webapp/skywalking-webapp.jar --spring.config.location=${WEBAPP_CONFIG} --logging.file=${LOG_FILE_LOCATION} 


