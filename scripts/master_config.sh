#!/bin/bash
set -ex
set -o pipefail

echo "CREATE ROLE repl WITH REPLICATION PASSWORD 'password' LOGIN;" | "${psql[@]}"

sed -i -e 's/^#listen_addresses/listen_addresses = "*"/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^wal_level/lwal_level = hot_standby/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^full_page_writes/full_page_writes = on/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^wal_log_hints/wal_log_hints = on/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^max_wal_senders/max_wal_senders = 6/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^max_replication_slots/max_replication_slots = 6/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^hot_standby/hot_standby = on/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^hot_standby_feedback/hot_standby_feedback = on/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^checkpoint_segments/checkpoint_segments = 16/g' /etc/postgresql/10.4/main/postgresql.conf
sed -i -e 's/^wal_keep_segments/wal_keep_segments = 16/g' /etc/postgresql/10.4/main/postgresql.conf

echo "hostssl replication repl postgres-master/32  md5" >> /etc/postgresql/10.4/main/pg_hba.conf
echo "hostssl replication repl postgres-slave/32  md5" >> /etc/postgresql/10.4/main/pg_hba.conf

sudo systemctl restart postgresql

