#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

images="
openeuler/openeuler:20.03
openeuler/openeuler:22.03
openeuler/openeuler:22.03-lts-sp1
openeuler/openeuler:22.03-lts-sp2
"

test_file="openeuler.sh"

for image in $images
do
  run_docker
done

