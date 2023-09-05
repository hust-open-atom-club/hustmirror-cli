#!/bin/bash
set -e

config_file="/etc/apt/sources.list"
new_config_file="$config_file"
if ! [[ -f "$config_file" ]]; then
  config_file="/etc/apt/sources.list.d/debian.sources"
fi

update_command="apt-get update"
recover_item="debian"

source "$(realpath ${BASH_SOURCE%/*})/run_test.sh"
