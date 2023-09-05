#!/usr/bin/env bash
set -e

source "$(realpath ${BASH_SOURCE%/*}/..)/utils.sh"

image="archlinux:latest"
test_file="arch.sh"
run_docker
