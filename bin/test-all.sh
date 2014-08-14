#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SPARK_DIR=$ROOT_DIR/spark

source $ROOT_DIR/bin/env.sh
source $ROOT_DIR/bin/utils.sh

PROJECTS=( "flume" "flume-polling" "kafka" )
RESULTS=()
for PROJECT in "${PROJECTS[@]}" ; do 
  echo
  echo "----------- $PROJECT -----------" 
  $ROOT_DIR/$PROJECT/bin/test.sh
  if [[ $? -eq 0 ]]; then 
    RESULTS+=( "$PROJECT: PASSED" )
  else
    RESULTS+=( "$PROJECT: FAILED" )
  fi
done

echo
echo "============= RESULTS =============="
echo
for RESULT in "${RESULTS[@]}" ; do 
  echo "  $RESULT"
done
echo "===================================="
