ARG BASEIMAGE

FROM $BASEIMAGE
MAINTAINER thijs.lemmens@xenit.eu

ARG PGVERSION

ARG INSTALL_PGLOGICAL

# Only install pglogical if configured
RUN if [ "${INSTALL_PGLOGICAL}" = "TRUE" ]; then \
  apt-get update && apt-get install -y wget gnupg \
  && echo "deb [arch=amd64] http://packages.2ndquadrant.com/pglogical/apt/ stretch-2ndquadrant main" > /etc/apt/sources.list.d/2ndquadrant.list \
  && wget --quiet -O - http://packages.2ndquadrant.com/pglogical/apt/AA7A6805.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y postgresql-${PGVERSION}-pglogical \
  && apt-get remove -y wget \
  && rm -rf /var/lib/apt/lists/* ; \
  fi

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