#!/bin/sh
echo
if [ "$PGHBAREPLACE" = "true" ]
then
    echo "Removing existing pg_hba.conf"
    rm -f "$PGDATA/pg_hba.conf"
    echo
    echo "Setting pg_hba.conf"
    IFS=$'\n'
    for i in `env`
    do
	if echo $i | grep "^PGHBA_.*" > /dev/null ;
	    then
	    key=`echo $i | cut -d '=' -f 1 | cut -d '_' -f 2-`
	    value=`echo $i | cut -d '=' -f 2-`
	    echo "Adding line to pg_hba.conf ($key):"
	    echo $value
	    echo
        echo "$value" >> "$PGDATA/pg_hba.conf"
	fi
    done
fi