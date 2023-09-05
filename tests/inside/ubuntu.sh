#!/bin/bash
set -e

config_file="/etc/apt/sources.list"
update_command="apt-get update"
recover_item="ubuntu"

source "$(realpath ${BASH_SOURCE%/*})/run_test.sh"
