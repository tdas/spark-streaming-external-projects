#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SPARK_DIR=$ROOT_DIR/spark

source $ROOT_DIR/bin/env.sh
source $ROOT_DIR/bin/utils.sh

CURRENT_DIR=`pwd`
cd $ROOT_DIR
download_spark_if_not_exists "$SPARK_DIR" "$SPARK_GIT_URL" "$SPARK_GIT_BRANCH"
