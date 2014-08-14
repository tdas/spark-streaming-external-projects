#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
KAFKA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $ROOT_DIR/bin/utils.sh
source $ROOT_DIR/bin/setup.sh
source $KAFKA_DIR/bin/env.sh

CURRENT_DIR=`pwd`
KAFKA_BIN_DIR="kafka_$KAFKA_SCALA_VERSION-$KAFKA_VERSION"
KAFKA_TAR_FILE="kafka_$KAFKA_SCALA_VERSION-$KAFKA_VERSION.tar.gz"
KAFKA_DIST_URL="https://archive.apache.org/dist/kafka/"
cd $KAFKA_DIR
download_if_not_exist "$KAFKA_TAR_FILE"  "$KAFKA_DIST_URL/$KAFKA_VERSION/$KAFKA_TAR_FILE" 
untar_if_not_exist "$KAFKA_BIN_DIR" "$KAFKA_TAR_FILE"
