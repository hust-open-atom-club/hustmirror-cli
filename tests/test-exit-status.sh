#!/usr/bin/env bash
#
# Regression test for the exit-status aggregation of tests/test.sh.
#
# Verifies, without a Docker daemon, that:
#   - run_docker() returns non-zero when the "pass" marker is missing;
#   - a failing case does not stop the following cases from running;
#   - test.sh exits non-zero when any case failed, and zero when all pass.
#
set -u

HERE=$(cd "${BASH_SOURCE[0]%/*}" && pwd)

run_case() {
  # $1: pass|fail, $2: expected test.sh exit code
  local mode="$1" expected="$2"
  local work
  work=$(mktemp -d)

  mkdir -p "$work/tests/outside" "$work/bin"
  cp "$HERE/utils.sh" "$HERE/test.sh" "$work/tests/"

  # Fake docker: creates the "pass" marker only when mode=pass.
  cat > "$work/bin/docker" <<EOF
#!/bin/sh
mode="$mode"
for arg in "\$@"; do
  case "\$arg" in
    *:/hmtest_log) ldir="\${arg%:/hmtest_log}";;
  esac
done
if [ -n "\${ldir:-}" ] && [ "\$mode" = pass ]; then
  : > "\$ldir/pass"
fi
exit 0
EOF
  chmod +x "$work/bin/docker"

  # Two cases: one matches the requested mode, the other always passes,
  # so we can also observe that a failure does not abort the run.
  cat > "$work/tests/outside/01_case.sh" <<EOF
image="fake:case"
params=()
test_file="run_test.sh"
. "$work/tests/utils.sh"
run_docker
EOF
  cat > "$work/tests/outside/02_always_pass.sh" <<EOF
echo "TESTING second case...\\tPASS"
true
EOF

  (
    cd "$work" || exit 99
    PATH="$work/bin:$PATH" bash tests/test.sh >"$work/out.log" 2>&1
    echo $? > "$work/rc"
  )

  local rc
  rc=$(cat "$work/rc")
  if [ "$rc" -ne "$expected" ]; then
    echo "FAIL: mode=$mode expected exit $expected, got $rc"
    sed 's/^/  | /' "$work/out.log"
    rm -rf "$work"
    return 1
  fi
  # The always-passing second case must have run in both modes.
  if ! grep -q "TESTING second case" "$work/out.log"; then
    echo "FAIL: mode=$mode - second case did not run"
    rm -rf "$work"
    return 1
  fi
  echo "ok: mode=$mode -> exit $rc"
  rm -rf "$work"
  return 0
}

status=0
run_case pass 0 || status=1
run_case fail 1 || status=1
exit $status
