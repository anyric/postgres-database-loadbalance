FROM ubuntu:16.04
LABEL Maintainer="Anyama Richard"

WORKDIR /app
RUN apt-get update && apt-get install -y vim wget

# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main "  >> /etc/apt/sources.list.d/pgdg.list

# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && apt-get update

# RUN apt-get install -y postgresql-9.6

COPY ./scripts/master.sh  /app

# RUN ls

# RUN . /app/master.sh


