#!/usr/bin/env sh
# httpmirror-cli - a CLI posix shell script to replace softwares' registry mirror

@var(sed "s/^/# /" LICENSE)

set -e

@include config.cfg

build_time="@var(date -u +'%Y-%m-%d %H:%M:%S UTC')"

@include utils.sh
@include help.sh

set_default_domain $domains
http="https"

# Not only to replace distributions but also softwares like pypi,
# npm registry, dockerhub, etc.
supported_softwares="@var(ls -1 src/mirrors/* | sed -E 's/^.+\/(.+)\.[^.]*$/\1/')"

_backup_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hustmirror/backup"

@mirrors

@include core.sh
@include cli.sh
@include interact.sh
@include bootstrap.sh

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
