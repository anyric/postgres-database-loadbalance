FROM postgres:10.4
LABEL maintainer="Anyama Richard"

RUN psql CREATE ROLE repl WITH REPLICATION PASSWORD 'password' LOGIN;
