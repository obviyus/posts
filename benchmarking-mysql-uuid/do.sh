#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <time to run>"
    exit 1
fi

for script in "$SCRIPTPATH"/uuid_*.lua
do
  echo "Running $(basename "$script" .lua)"
  sysbench "$script" --threads=16 --warmup-time=30 --mysql-user=benchmark --mysql-password=password --mysql-db=benchmark --report-interval=1 --time=$1 run > "$(basename "$script" .lua)""_$1".log

  # Drop all MySQL tables
  mysql -ubenchmark -ppassword -e "DROP DATABASE benchmark; CREATE DATABASE benchmark;"
done
