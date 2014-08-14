#!/bin/bash

FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
FLUME_LOG=$FLUME_DIR/flume.log
SPARK_LOG=$FLUME_DIR/spark.log


# Run if the scripts is asked to be terminated
stop_test()
{
  echo "Signal intercepted, stopping tests"
  kill $(jobs -p)
  if [[ ! -z "$SPARK_PID" ]] ; then 
    wait $SPARK_PID
    echo "Stopped Spark"
  fi
  if [[ ! -z "$FLUME_PID" ]] ; then 
    wait $FLUME_PID
    echo "Stopped Flume"
  fi
}

trap stop_test SIGINT SIGKILL SIGTERM 

# Run Flume in background
$FLUME_DIR/bin/run-flume.sh > $FLUME_LOG 2>&1 & 
FLUME_PID=$( jps -l | grep "org.apache.flume.node.Application" | awk '{ print $1 }' | head -1)
echo "Started Flume with logs going to $FLUME_LOG and PID $FLUME_PID"
sleep 2

# Run Spark Streaming and wait for it to finish
$FLUME_DIR/bin/run-spark.sh > $SPARK_LOG 2>&1 &
SPARK_PID=$!
echo "Started Spark with logs going to $SPARK_LOG and PID $SPARK_PID"
wait $SPARK_PID
echo Stopped Spark

# Stop Flume
kill -SIGKILL $FLUME_PID > /dev/null 2>&1
echo Stopped Flume

# Verify
if ( grep -q "PASSED" $SPARK_LOG ) ; then
  echo "TEST PASSED"
else 
  echo "TEST FAILED"
  exit -1
fi

