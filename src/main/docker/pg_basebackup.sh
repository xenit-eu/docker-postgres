#!/bin/sh

if [[ ! -d "$PGDATA" ]]; then mkdir -p "$PGDATA"; fi
chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ] && ! [ -z "${PG_BASEBACKUP_DBNAME}" ]; then
    echo "Doing pg_basebackup"
    gosu postgres pg_basebackup -D "$PGDATA" -X stream -R -P -d "$PG_BASEBACKUP_DBNAME"
    echo "pg_basebackup finished"
    chmod 0700 "$PGDATA"
fi