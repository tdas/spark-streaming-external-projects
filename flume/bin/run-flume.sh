#!/bin/bash

FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $FLUME_DIR/bin/env.sh
source $FLUME_DIR/bin/setup.sh

$FLUME_DIR/apache-flume-$FLUME_VERSION-bin/bin/flume-ng agent --conf $FLUME_DIR/apache-flume-$FLUME_VERSION-bin/conf --conf-file $FLUME_DIR/conf/flume-conf.properties -name agent


