#!/usr/bin/env bash
set -e

ROOT_DIR=$(realpath `pwd`/../../)

images="
openeuler/openeuler:20.03
openeuler/openeuler:22.03
openeuler/openeuler:22.03-lts-sp1
openeuler/openeuler:22.03-lts-sp2
"


for image in $images
do
  printf "TESTING $image...\t"
  LDIR=$ROOT_DIR/tests/log/${image/:/_}
  mkdir -p $LDIR
  docker run -it --rm \
    -v $ROOT_DIR/output:/hustmirror \
    -v $ROOT_DIR/tests/inside:/hmtest \
    -v $LDIR:/hmtest_log \
    $image bash -c "/hmtest/openeuler.sh >/hmtest_log/output.log 2>&1" \
    > $LDIR/docker_output.log 2> $LDIR/docker_output.err || true

  if [ -f $LDIR/pass ]; then
    printf "PASS \n"
  else
    printf "\033[0;31m FAIL!!! \033[0m \n"
  fi
done

