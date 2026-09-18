#!/usr/bin/env sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cli="$root_dir/output/hustmirror-cli"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' 0 HUP INT TERM

export HOME="$test_dir/home"
export XDG_CONFIG_HOME="$test_dir/config"
mkdir -p "$HOME" "$XDG_CONFIG_HOME"

unknown_output="$test_dir/unknown-command.log"
if "$cli" definitely-not-a-command >"$unknown_output" 2>&1; then
	echo "unknown command unexpectedly returned exit status 0" >&2
	cat "$unknown_output" >&2
	exit 1
fi

if ! grep -F "Unknown argument definitely-not-a-command" "$unknown_output" >/dev/null; then
	echo "unknown command did not print the expected error" >&2
	cat "$unknown_output" >&2
	exit 1
fi

"$cli" --help >/dev/null
"$cli" --version >/dev/null

echo "CLI argument tests passed."
