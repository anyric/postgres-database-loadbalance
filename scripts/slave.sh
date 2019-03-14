#!/bin/bash
set -ex

echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main "  >> /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
apt-get update
apt-get install -y postgresql-9.6
/etc/init.d/postgresql start

sed -i -e "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/postgresql/9.6/main/pg_hba.conf
sed -i -e 's/32/0/g' /etc/postgresql/9.6/main/pg_hba.conf
export PATH=$PATH:/usr/lib/postgresql/9.6/bin

/etc/init.d/postgresql stop

sed -i -e 's/^#wal_level = minimal/wal_level = hot_standby/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#max_wal_senders = 0/max_wal_senders = 5/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#wal_keep_segments = 0/wal_keep_segments = 32/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#hot_standby = off/hot_standby = on/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#archive_mode = off/archive_mode = on/g' /etc/postgresql/9.6/main/postgresql.conf

echo "host      replication         repl              postgres-master           md5" >> /etc/postgresql/9.6/main/pg_hba.conf

/etc/init.d/postgresql start
/etc/init.d/postgresql restart
