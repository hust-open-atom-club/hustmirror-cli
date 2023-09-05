#!/bin/bash
set -e

# close stdin
exec 0<&-

echo "---------"
echo "apt dir"
echo "---------"
ls /etc/apt

echo "---------"
echo "Origin file"
echo "---------"

cat /etc/apt/sources.list || true


echo "---------"
echo "Running deploy"
echo "---------"
HM_HTTP=http /hustmirror/hust-mirror.sh autodeploy

echo "---------"
echo "New file"
echo "---------"
cat /etc/apt/sources.list

echo "---------"
echo "apt-get update"
echo "---------"
apt-get update && touch /hmtest_log/pass
