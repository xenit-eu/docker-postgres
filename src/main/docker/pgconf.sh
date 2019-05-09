#!/bin/sh

setPGConfOptions() {
    echo "Setting postgresql.conf options"
    IFS=$'\n'
    for i in `env`
    do
	if echo $i | grep "^PGCONF_.*" > /dev/null ;
	    then
	    key=`echo $i | cut -d '=' -f 1 | cut -d '_' -f 2-`
	    value=`echo $i | cut -d '=' -f 2-`
	    PG_ARGUMENTS+=( '-c' )
	    PG_ARGUMENTS+=( "$key=$value" )
	fi
    done
}
setPGConfOptions