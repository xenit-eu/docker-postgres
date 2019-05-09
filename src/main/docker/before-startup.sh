#!/usr/bin/env bash

set -e

# initialise the array with arguments
export PG_ARGUMENTS=()

echo
echo "Running scripts before startup"
echo

if [ "$1" = 'postgres' ]; then
    for f in /before-startup/*; do
        case "$f" in
            *.sh)     echo "$0: running $f"; . "$f" ;;
            *)        echo "$0: ignoring $f" ;;
        esac
        echo
    done
fi

echo
echo "Done running before startup scripts"
echo

if [[ -v PG_ARGUMENTS ]]; then
  echo "executing with PG_ARGUMENTS"
  echo "${PG_ARGUMENTS[@]}"
  exec "$@" ${PG_ARGUMENTS[@]}
else
  echo "PG_ARGUMENTS not set, executing without"
  exec "$@"
fi