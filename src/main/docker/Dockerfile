ARG BASEIMAGE

FROM $BASEIMAGE

ARG PGVERSION
ARG WALGVERSION

# Only install pglogical if configured
RUN apt-get update && apt-get install -y wget \
  && wget -q https://access.2ndquadrant.com/api/repository/dl/default/release/deb | bash \
  && apt-get install -y postgresql-${PGVERSION}-pglogical \
  && wget -qO- https://github.com/wal-g/wal-g/releases/download/${WALGVERSION}/wal-g.linux-amd64.tar.gz | tar zxv -C /usr/bin/ \
  && apt-get remove -y wget \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data/PGDATA
VOLUME /var/lib/postgresql/data

COPY before-startup.sh /
RUN chmod +x /before-startup.sh
RUN sed -i "s/exec \"\\$\@\"/exec \/before-startup.sh \"\\$\@\"/" /usr/local/bin/docker-entrypoint.sh
RUN mkdir /before-startup

COPY before-init.sh /
RUN chmod +x /before-init.sh
RUN sed -i "0,/set -e/s//set -e \n\n#Before init hook\n\/before-init.sh/" /usr/local/bin/docker-entrypoint.sh
RUN mkdir /before-init

COPY pgconf.sh /before-startup/
COPY pghba.sh /before-startup/
COPY pg_basebackup.sh /before-init/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 5432