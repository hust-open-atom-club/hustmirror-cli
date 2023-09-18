#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

# http="http"
images="kalilinux/kali-rolling"
test_file="kali.sh"

for image in $images
do
  run_docker
done

