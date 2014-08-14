#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $KAFKA_DIR/bin/env.sh

KAFKA_BIN_DIR="$KAFKA_DIR/kafka_$KAFKA_SCALA_VERSION-$KAFKA_VERSION"
ZOOKEEPER_LOG="$KAFKA_DIR/zookeeper.log"
KAFKA_SERVER_LOG="$KAFKA_DIR/kafka-server.log"
KAFKA_PRODUCER_LOG="$KAFKA_DIR/kafka-producer.log"

# Run if the scripts is asked to be terminated
stop_kafka()
{
  echo "Signal intercepted, stopping Zookeeper and Kafka"
  kill $(jobs -p)
  if [[ ! -z "$KAFKA_PRODUCER_PID" ]] ; then 
    wait $KAFKA_PRODUCER_PID 
    echo "Stopped Kafka producer"
  fi
  if [[ ! -z "$KAFKA_SERVER_PID" ]] ; then 
    wait $KAFKA_SERVER_PID
    echo "Stopped Kafka server"
  fi
  if [[ ! -z "$ZOOKEEPER_PID" ]] ; then 
    wait $ZOOKEEPER_PID 
    echo "Stopped Zookeeper" 
  fi
  exit 0
}

trap stop_kafka SIGINT SIGKILL SIGTERM

# Run Zookeeper in background
$KAFKA_BIN_DIR/bin/zookeeper-server-start.sh $KAFKA_BIN_DIR/config/zookeeper.properties > $ZOOKEEPER_LOG 2>&1 &
ZOOKEEPER_PID=$!
echo "Started Zookeeper with logs going to $ZOOKEEPER_LOG and PID $ZOOKEEPER_PID"
sleep 1

# Run Kafka server
$KAFKA_BIN_DIR/bin/kafka-server-start.sh $KAFKA_BIN_DIR/config/server.properties > $KAFKA_SERVER_LOG 2>&1 &
KAFKA_SERVER_PID=$!
echo "Started Kafka server with logs going to $KAFKA_SERVER_LOG and PID $KAFKA_SERVER_PID"
sleep 1

# Add Kafka topic
$KAFKA_BIN_DIR/bin/kafka-create-topic.sh --zookeeper localhost:2181 --replica 1 --partition 1 --topic test > /dev/null 2>&1

# Run Kafka producer
while [ 1 ] ; do date && sleep 0.1 ; done | $KAFKA_BIN_DIR/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test > $KAFKA_PRODUCER_LOG 2>&1 &
# $KAFKA_BIN_DIR/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 2>&1 | tee $KAFKA_PRODUCER_LOG &

KAFKA_PRODUCER_PID=$!
echo "Started Kafka producer with logs going to $KAFKA_PRODUCER_LOG and PID $KAFKA_PRODUCER_PID"
export KAFKA_PID=$$
wait $KAFKA_PRODUCER_PID

