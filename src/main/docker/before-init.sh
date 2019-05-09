#!/usr/bin/env bash

set -e

echo
echo "Running scripts before init"
echo

for f in /before-init/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

echo
echo "Done running before init scripts"
echo