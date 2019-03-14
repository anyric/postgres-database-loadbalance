FROM ubuntu:16.04
LABEL Maintainer="Anyama Richard"

WORKDIR /app

RUN apt-get update && apt-get -y install apt-transport-https curl

RUN apt-get update && apt-get install -y vim wget

COPY ./scripts/slave.sh /app

COPY ./scripts/slave_startup.sh /app

RUN /bin/bash -c "source /app/slave.sh"

RUN /etc/init.d/postgresql start

# Expose the PostgreSQL port
EXPOSE 5432
 
# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
 
USER postgres
CMD ["/usr/lib/postgresql/9.6/bin/postgres", "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf"]