#!/usr/bin/env bash
set -e
set -o pipefail
 
dir=${BASH_SOURCE%/*}
cd $dir/outside

echo "HUSTMIRROR testing script"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found"
  exit 1
fi

failed=0
for test_file in $(ls ./*)
do
  if [ $test_file == "./test.sh" ]; then
    continue
  fi

  echo "RUNNING $test_file..."
  # Keep running the remaining cases even if one of them fails; record the
  # failure and report it through the final exit status.
  if ! . $test_file; then
    failed=1
  fi
done

if [ $failed -ne 0 ]; then
  echo "FAILED: at least one test case did not pass"
  exit 1
fi

echo "ALL TESTS PASSED"
