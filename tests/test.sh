#!/usr/bin/env bash
 
dir=${BASH_SOURCE%/*}
cd $dir/outside

echo "HUSTMIRROR testing script"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found"
  exit 1
fi

for test_file in $(ls ./*)
do
  if [ $test_file == "./test.sh" ]; then
    continue
  fi

  echo "RUNNING $test_file..."
  . $test_file
done
