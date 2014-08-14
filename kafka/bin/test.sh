#!/bin/bash

KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

KAFKA_LOG=$KAFKA_DIR/flume.log
SPARK_LOG=$KAFKA_DIR/spark.log

# Run Kafka in background
$KAFKA_DIR/bin/run-kafka.sh 2>&1 & 
KAFKA_PID=$!
sleep 2

# Run Spark Streaming and wait for it to finish
$KAFKA_DIR/bin/run-spark.sh > $SPARK_LOG 2>&1 &
SPARK_PID=$!
echo "Started Spark with logs going to $SPARK_LOG"
wait $SPARK_PID
echo Stopped Spark

# Stop Kafka 
kill -s 9 $KAFKA_PID > /dev/null 2>&1
echo Stopped Kafka 

# Verify
if ! ( grep -q "PASSED" $KAFKA_LOG ) ; then
  echo "TEST PASSED"
else 
  echo "TEST FAILED"
  exit -1
fi

