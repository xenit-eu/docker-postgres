![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/postgres/logo.png)

# How to use this image

## start a postgres instance

```console
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d xeniteu/postgres
```

or with docker-compose: 

```yaml
postgresql:
    image: xeniteu/postgres
    ports:
    - 5432:5432
    volumes:
    - postgres:/var/lib/postgresql/data
    environment:
    - POSTGRES_USER=my_user
    - POSTGRES_PASSWORD=my_password
    - POSTGRES_DB=my_db
```

This image includes `EXPOSE 5432` (the postgres port), so standard container linking will make it automatically available to the linked containers. The default `postgres` user and database are created in the entrypoint with `initdb`.

> The postgres database is a default database meant for use by users, utilities and third party applications.  
> [postgresql.org/docs](https://www.postgresql.org/docs/current/app-initdb.html)

## connect to it from an application

```console
$ docker run --name some-app --link some-postgres:postgres -d application-that-uses-postgres
```

## ... or via `psql`

```console
$ docker run -it --link some-postgres:postgres --rm postgres sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
```

## Environment Variables

The PostgreSQL image uses several environment variables which are easy to miss. While none of the variables are required, they may significantly aid you in using the image.

### `POSTGRES_PASSWORD`

This environment variable is recommended for you to use the PostgreSQL image. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable. In the above example, it is being set to "mysecretpassword".

### `POSTGRES_USER`

This optional environment variable is used in conjunction with `POSTGRES_PASSWORD` to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of `postgres` will be used.

### `PGDATA`

This optional environment variable can be used to define another location - like a subdirectory - for the database files. The default is `/var/lib/postgresql/data`, but if the data volume you're using is a fs mountpoint (like with GCE persistent disks), Postgres `initdb` recommends a subdirectory (for example `/var/lib/postgresql/data/pgdata` ) be created to contain the data.

### `POSTGRES_DB`

This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, than the value of `POSTGRES_USER` will be used.

### `PG_BASEBACKUP_DBNAME`

This optional environment variable triggers a basebackup when starting with an empty `PGDATA` folder. Also, it creates a recovery file and the postgres will automatically start in hot standby mode. This variable will be used as the `-d (--dbname)` argument for the `pg_basebackup` command. Example:
`host=masterhostname port=5432 user=replication password=hello123`

### `PGCONF_*`

You can override any property in posgresql.conf by specifying an environment variable `PGCONF_{conf_key}={conf_value}`. Example: `PGCONF_hot_standby=on` .

### `PGHBAREPLACE` and `PGHBA_*`

Setting `PGHBAREPLACE=true` will remove the pg_hba.conf and will search for all `PGHBA_*` environment variables, and put the values in a clean pg_hba.conf.

# Source

This image is based on [github.com/docker-library/postgres](https://github.com/docker-library/postgres/) and extends it with:

* [pglogical](https://www.2ndquadrant.com/en/resources/pglogical/)
* [WAL-G](https://github.com/wal-g/wal-g)
