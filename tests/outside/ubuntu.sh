#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

images="
ubuntu:23.04
ubuntu:22.04
ubuntu:20.04
"

test_file="ubuntu.sh"

for image in $images
do
  run_docker
done

