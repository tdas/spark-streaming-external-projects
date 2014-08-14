#!/bin/bash


ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $KAFKA_DIR/bin/env.sh

KAFKA_BIN_DIR="$KAFKA_DIR/kafka_$KAFKA_SCALA_VERSION-$KAFKA_VERSION"
ZOOKEEPER_LOG="$KAFKA_DIR/zookeeper.log"
KAFKA_SERVER_LOG="$KAFKA_DIR/kafka-server.log"
KAFKA_PRODUCER_LOG="$KAFKA_DIR/kafka-producer.log"

control_c()
# run if user hits control-c
{
  if [[ ! -z "$KAFKA_PRODUCER_PID" ]] ; then 
    echo "Stopping Kafka producer"
    kill -s 2 $KAFKA_PRODUCER_PID 
    echo "Stopped Kafka producer"
  fi
  if [[ ! -z "$KAFKA_SERVER_PID" ]] ; then 
    echo "Stopping Kafka server"
    kill -s 2 $KAFKA_SERVER_PID
    echo "Stopped Kafka server"
  fi
  if [[ ! -z "$ZOOKEEPER_PID" ]] ; then 
    echo "Stopping Zookeeper" 
    kill -s 2 $ZOOKEEPER_PID 
    echo "Stopped Zookeeper" 
  fi
  exit 0
}

trap control_c SIGINT

# Run Zookeeper
$KAFKA_BIN_DIR/bin/zookeeper-server-start.sh $KAFKA_BIN_DIR/config/zookeeper.properties > $ZOOKEEPER_LOG 2>&1 &
ZOOKEEPER_PID=$!
echo "Started Zookeeper with logs going to $ZOOKEEPER_LOG and PID $ZOOKEEPER_PID"
sleep 2

# Run Kafka server
$KAFKA_BIN_DIR/bin/kafka-server-start.sh $KAFKA_BIN_DIR/config/server.properties > $KAFKA_SERVER_LOG 2>&1 &
KAFKA_SERVER_PID=$!
echo "Started Kafka server with logs going to $KAFKA_SERVER_LOG"
sleep 2

# Add Kafka topic
$KAFKA_BIN_DIR/bin/kafka-create-topic.sh --zookeeper localhost:2181 --replica 1 --partition 1 --topic test > /dev/null 2>&1

# Run Kafka producer
while [ 1 ] ; do date && sleep 0.01 ; done | $KAFKA_BIN_DIR/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test > $KAFKA_PRODUCER_LOG 2>&1 &
KAFKA_PRODUCER_PID=$!
echo "Started Kafka producer with logs going to $KAFKA_PRODUCER_LOG"
echo 
echo "Press Ctrl-C to stop"
wait $KAFKA_PRODUCER_PID





 

