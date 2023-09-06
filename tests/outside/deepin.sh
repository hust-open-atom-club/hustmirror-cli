#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

images="
linuxdeepin/beige
linuxdeepin/apricot
"
# http="http"
test_file="deepin.sh"

for image in $images
do
  run_docker
done

