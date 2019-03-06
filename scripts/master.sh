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

su -c "psql -c \"CREATE ROLE repl WITH REPLICATION PASSWORD 'password' LOGIN;\"" postgres

/etc/init.d/postgresql stop

sed -i -e 's/^#wal_level = minimal/wal_level = hot_standby/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#max_wal_senders = 0/max_wal_senders = 5/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#wal_keep_segments = 0/wal_keep_segments = 32/g' /etc/postgresql/9.6/main/postgresql.conf
sed -i -e 's/^#archive_mode = off/archive_mode = on/g' /etc/postgresql/9.6/main/postgresql.conf
# sed -i -e "s/^#archive_command=''/archive_command = 'cp \%p /var/lib/postgresql/9.6/archive/\%f'/g" /etc/postgresql/9.6/main/postgresql.conf
echo "archive_command = 'cp %p /var/lib/postgresql/9.6/archive/%f'" >> /etc/postgresql/9.6/main/postgresql.conf
mkdir /var/lib/postgresql/9.6/archive
chown postgres.postgres /var/lib/postgresql/9.6/archive

echo "host    repl    replication   postgres-slave     md5" >> /etc/postgresql/9.6/main/pg_hba.conf

/etc/init.d/postgresql start
/etc/init.d/postgresql restart
