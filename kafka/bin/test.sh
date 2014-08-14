#!/bin/bash

KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

SPARK_LOG=$KAFKA_DIR/spark.log

# Run if the scripts is asked to be terminated
stop_test()
{
  echo "Signal intercepted, stopping tests"
  kill $(jobs -p)
  if [[ ! -z "$SPARK_PID" ]] ; then 
    wait $SPARK_PID
    echo "Stopped Spark"
  fi
  if [[ ! -z "$KAFKA_PID" ]] ; then 
    wait $KAFKA_PID 
    echo "Stopped Kafka-related processes"
  fi
}

trap stop_test SIGINT SIGKILL SIGTERM 

# Run Kafka in background
$KAFKA_DIR/bin/run-kafka.sh 2>&1 &
KAFKA_PID=$!
sleep 5
echo "Started all Kafka-related processes, main PID $KAFKA_PID"

# Run Spark Streaming and wait for it to finish
rm -f $SPARK_LOG 2> /dev/null
$KAFKA_DIR/bin/run-spark.sh > $SPARK_LOG 2>&1 &
SPARK_PID=$!
echo "Started Spark with logs going to $SPARK_LOG and PID $SPARK_PID"
wait $SPARK_PID
echo "Stopped Spark"

# Stop Kafka
kill -SIGTERM $KAFKA_PID
wait $KAFKA_PID
echo "Stopped all Kafka-related processes"

# Verify
if ( grep -q "PASSED" $SPARK_LOG ) ; then
  echo "TEST PASSED"
else 
  echo "TEST FAILED"
  exit -1
fi

