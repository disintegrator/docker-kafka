#!/bin/sh

export KAFKA_OPTS="-Dkafka.logs.dir=/var/log/kafka -Dlog4j.configuration=file:/opt/kafka/config/log4j.properties"
python /opt/kafka/env_template.py /opt/kafka/config
/opt/kafka/kafka_2.9.2-0.8.1/bin/kafka-server-start.sh /opt/kafka/config/server.properties

