#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Download a file from an URL if the file does not exist
# Usage: download_if_not_exist "file_xyz" "https://xyz.com/"
#
download_if_not_exist () 
{
  FILE=$1
  URL=$2

  if [[ ! -f "$FILE" ]]; then
    # Download the file from the url
    echo "Attempting to fetch $FILE from $URL"
    FILE_PART=${FILE}.part
    if hash curl 2>/dev/null; then
      curl --progress-bar ${URL} > ${FILE_PART} && mv ${FILE_PART} ${FILE}
    elif hash wget 2>/dev/null; then
      wget --progress=bar ${URL} -O ${FILE_PART} && mv ${FILE_PART} ${FILE}
    else
      echo "You do not have curl or wget installed, please manually download $FILE from $URL"
      quit 
    fi
    if [[ ! -f "$FILE" ]]; then
      # We failed to download
      echo "We failed to download $FILE from $URL, please manually download $FILE"
      quit
    else 
      echo "Successfully downloaded $FILE"
    fi
  fi
}


# Untar the tarball, if the untarred directory does not exist
# Usage: untar_if_not_exist  "untar_directory" "tar.gz" 
#
untar_if_not_exist () 
{
  UNTAR_DIR=$1
  TAR_FILE=$2

  if [[ ! -d "$UNTAR_DIR" ]]; then
    if [[ -f "$TAR_FILE" ]]; then 
      # Untar the tarball
      echo "Untarring $TAR_FILE"
      echo "tar xzf $TAR_FILE"
      tar xzf $TAR_FILE
    else
      echo "$TAR_FILE not found, please download it manually"
      quit 
    fi
    if [[ ! -d "$UNTAR_DIR" ]]; then
      echo "We failed to untar $TAR_FILE, please manually download $TAR_FILE and untar it"
      quit 
    else
      echo "Successfully untarred $TAR_FILE"
    fi
  fi
}

download_spark_if_not_existsi_old ()
{
  SPARK_DIR=$1
  SPARK_BINARY_URL=$2

  if [[ ! -d "$SPARK_DIR" ]] ; then
    echo "Spark directory $SPARK_DIR not found, downloading it"
    rm -rf spark*
    download_if_not_exist "spark.tgz" "$SPARK_BINARY_URL" || quit
    echo "Extracting Spark"
    tar xvf "spark.tgz"
    existing_spark_dirs=`find . -name spark-*-bin* `
    echo "[$existing_spark_dirs]"
    if [[ -n "$existing_spark_dirs" ]] ; then
      temp=( $existing_spark_dirs )
      echo mv "${temp[0]}" $SPARK_DIR
      mv "${temp[0]}" $SPARK_DIR
    fi
    if [[ ! -d "$SPARK_DIR" ]] ; then
      echo "Could not download spark, please manually download your desired binary release of Spark and create directory $ROOT_DIR/spark"
      quit
    fi 
  fi
}

download_spark_if_not_exists ()
{
  DIR=$1
  GIT_URL=$2
  GIT_BRANCH=$3

  if [[ ! -d "$DIR" ]] ; then
    echo "Spark directory $DIR not found, downloading it"
    git clone --branch $GIT_BRANCH $GIT_URL $DIR || quit "Could not download Spark, please manually git clone the required version of Spark in $ROOT_DIR/spark"
  fi 
  if ! ( find spark/assembly/target/scala-2.10/ | grep -q "spark-assembly-[A-Za-z0-9.\-]*.jar$" ) ; then
    echo "Compiling and publishing Spark"
    cd spark
    sbt/sbt package publish-local assembly || quit "Could not find compiled Spark assembly, please compiling it manually using 'sbt/sbt package assembly' inside $ROOT_DIR/spark"
  fi
}

quit ()
{
  if [[ -z "$1" ]]; then 
    echo $1
  fi
  if [[ -z "$CURRENT_DIR" ]]; then
    cd $CURRENT_DIR
  fi
  exit -1
}

