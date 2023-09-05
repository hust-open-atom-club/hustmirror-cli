#!/bin/bash
set -e

# close stdin
exec 0<&-

echo "---------"
echo "pacman dir"
echo "---------"
ls /etc/pacman.d/

echo "---------"
echo "Origin file"
echo "---------"
cat /etc/pacman.d/mirrorlist || true


echo "---------"
echo "Running deploy"
echo "---------"
HM_HTTP=http /hustmirror/hust-mirror.sh autodeploy

echo "---------"
echo "New file"
echo "---------"
cat /etc/pacman.d/mirrorlist || true

echo "---------"
echo "pacman update"
echo "---------"
pacman -Syy && touch /hmtest_log/pass
