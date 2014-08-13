#!/bin/bash


HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
FLUME_HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $HOME_DIR/bin/utils.sh
source $HOME_DIR/bin/setup.sh

source $FLUME_HOME_DIR/bin/env.sh

CURRENT_DIR=`pwd`
cd $FLUME_HOME_DIR
download_if_not_exist "apache-flume-$FLUME_VERSION-bin.tar.gz"  "http://archive.apache.org/dist/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz" 
untar_if_not_exist "apache-flume-$FLUME_VERSION-bin" "apache-flume-$FLUME_VERSION-bin.tar.gz" 


