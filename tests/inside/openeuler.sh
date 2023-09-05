#!/bin/bash
set -e

config_file="/etc/yum.repos.d/openEuler.repo"
update_command="yum makecache"
recover_item="openeuler"

source "$(realpath ${BASH_SOURCE%/*})/run_test.sh"
