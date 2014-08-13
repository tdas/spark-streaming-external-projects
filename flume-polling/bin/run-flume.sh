#!/bin/bash

FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $ROOT_DIR/bin/env.sh
source $FLUME_DIR/bin/env.sh
source $FLUME_DIR/bin/setup.sh

# Get path to Spark's Flume Sink jar
SPARK_FLUME_SINK_JAR_DIR=$SPARK_DIR/external/flume-sink/target/scala-2.10/
if ! ( find $SPARK_FLUME_SINK_JAR_DIR | grep -q "spark-streaming-flume-sink_[0-9A-Z.\-]*.jar$" ) ; then
  echo "Could not find Spark's Flume Sink jar in $SPARK_FLUME_SINK_JAR_DIR, please run 'sbt/sbt package' in $SPARK_DIR"
  exit -1
fi
SPARK_FLUME_SINK_JAR=$( find $SPARK_FLUME_SINK_JAR_DIR | grep "spark-streaming-flume-sink_[0-9A-Z.\-]*.jar$" | head -1 )

# Get path to Scala jar
SCALA_JAR_DIR=$SPARK_DIR/lib_managed/jars/
if ! ( find $SCALA_JAR_DIR | grep -q "scala-library-[0-9.]*.jar$" ) ; then
  echo "Could not find Scala library jar in $SCALA_JAR_DIR, please run 'sbt/sbt package' in $SPARK_DIR"
  exit -1
fi
SCALA_JAR=$( find $SCALA_JAR_DIR | grep "scala-library-[0-9.]*.jar$" | head -1 )

# Run Flume with the Sink jar and Scala jar
echo Running Flume with Spark\'s Flume Sink jar at $SPARK_FLUME_SINK_JAR and Scala library jar at $SCALA_JAR
$FLUME_DIR/apache-flume-$FLUME_VERSION-bin/bin/flume-ng agent --conf $FLUME_DIR/apache-flume-$FLUME_VERSION-bin/conf --conf-file $FLUME_DIR/conf/flume-conf.properties -name agent --classpath $SPARK_FLUME_SINK_JAR:$SCALA_JAR


