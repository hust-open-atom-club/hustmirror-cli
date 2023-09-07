#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

images="openkylinux/yangtze"
test_file="openkylin.sh"

for image in $images
do
  run_docker
done

