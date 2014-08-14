#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
FLUME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $ROOT_DIR/bin/utils.sh
source $ROOT_DIR/bin/setup.sh
source $FLUME_DIR/bin/env.sh

CURRENT_DIR=`pwd`
cd $FLUME_DIR
download_if_not_exist "apache-flume-$FLUME_VERSION-bin.tar.gz"  "http://archive.apache.org/dist/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz" 
untar_if_not_exist "apache-flume-$FLUME_VERSION-bin" "apache-flume-$FLUME_VERSION-bin.tar.gz" 


