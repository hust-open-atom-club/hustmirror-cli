#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

images="
debian:12-slim
debian:11-slim
debian:10-slim
debian:sid-slim
debian:testing-slim
"
test_file="debian.sh"


for image in $images
do
  if echo $image | grep -q "sid"; then
    params="-e HM_DEBIAN_SID=true"
  else
    params=""
  fi
  run_docker
done

