ROOT_DIR=$(realpath ${BASH_SOURCE[0]%/*}/../)

# before call this function, you should set $image, $params - an array, $test_file
run_docker() {
  printf "TESTING $image...\t"
  LDIR=$ROOT_DIR/tests/log/${image//[:\/]/_}
  rm -rf $LDIR
  mkdir -p $LDIR
  docker run -it --rm \
    -v $ROOT_DIR/output:/hustmirror \
    -v $ROOT_DIR/tests/inside:/hmtest \
    -v $LDIR:/hmtest_log \
    -w /hmtest_log \
    ${params[@]} \
    $image bash -c "bash /hmtest/$test_file >/hmtest_log/output.log 2>&1" \
    > $LDIR/docker_output.log 2> $LDIR/docker_output.err || true

  if [ -f $LDIR/pass ]; then
    printf "PASS \n"
  else
    printf "\033[0;31m FAIL!!! \033[0m \n"
  fi
}
