#!/bin/bash
set -e

config_file="/etc/apt/sources.list"
update_command="apt update"
recover_item="kali"

source "$(realpath ${BASH_SOURCE%/*})/run_test.sh"
