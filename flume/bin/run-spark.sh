#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $FLUME_DIR/bin/setup.sh

CURRENT_DIR=`pwd`
cd $FLUME_DIR
sbt/sbt assembly && $SPARK_DIR/bin/spark-submit --master "local[4]" --class FlumeEventCount $FLUME_DIR/target/scala-2.10/flume-app-assembly-0.1-SNAPSHOT.jar localhost 54321


