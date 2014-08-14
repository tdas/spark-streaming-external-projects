#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $ROOT_DIR/bin/env.sh
source $KAFKA_DIR/bin/env.sh
source $KAFKA_DIR/bin/setup.sh

CURRENT_DIR=`pwd`
cd $KAFKA_DIR
sbt/sbt assembly && $SPARK_DIR/bin/spark-submit --master "local[4]" --class KafkaEventCount $KAFKA_DIR/target/scala-2.10/kafka-app-assembly-0.1-SNAPSHOT.jar localhost:2181 group test 1


