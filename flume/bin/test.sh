#!/bin/bash

FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

FLUME_LOG=$FLUME_DIR/flume.log
SPARK_LOG=$FLUME_DIR/spark.log

# Run Flume in background
$FLUME_DIR/bin/run-flume.sh > $FLUME_LOG 2>&1 & 
FLUME_PID=$!
echo "Started Flume with logs going to $FLUME_LOG"
sleep 5

# Run Spark Streaming and wait for it to finish
$FLUME_DIR/bin/run-spark.sh > $SPARK_LOG 2>&1 &
SPARK_PID=$!
echo "Started Spark with logs going to $SPARK_LOG"
wait $SPARK_PID
echo Stopped Spark

# Stop Flume
kill -s 9 $FLUME_PID > /dev/null 2>&1
echo Stopped Flume

# Verify
if ! ( grep -q "PASSED" $FLUME_LOG ) ; then
  echo "TEST PASSED"
else 
  echo "TEST FAILED"
  exit -1
fi

