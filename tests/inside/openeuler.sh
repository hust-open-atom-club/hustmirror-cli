#!/bin/bash
set -e

# close stdin
exec 0<&-

echo "---------"
echo "Origin file"
echo "---------"
cat /etc/yum.repos.d/openEuler.repo || true


echo "---------"
echo "Running deploy"
echo "---------"
HM_HTTP=http /hustmirror/hust-mirror.sh autodeploy

echo "---------"
echo "New file"
echo "---------"
cat /etc/yum.repos.d/openEuler.repo || true

echo "---------"
echo "yum update"
echo "---------"
yum makecache && touch /hmtest_log/pass
