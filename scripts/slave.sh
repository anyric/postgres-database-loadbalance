#!/bin/bash
set -ex
set -o pipefail

sudo bash -c 'cat <<EOF> /etc/apt/sources.list.d/pgdg.list
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main
EOF'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update

sudo apt-get install postgresql-9.6

sudo systemctl status postgresql

sudo systemctl stop postgresql

sudo rm -rf /var/lib/postgresql/9.6/main/*

sudo su postgresql
pg_basebackup -h postgres-master -D /var/lib/postgresql/9.6/main --password=password -U repl --xlog-method=stream
exit
sed -i -e 's/^#hot_standby/hot_standby = on/g' /etc/postgresql/9.6/main/postgresql.conf

sudo bash -c "cat <<EOF> /var/lib/postgresql/9.6/main/recovery.conf
standby_mode      = 'on'
primary_conninfo  = 'host=postgres-master' port=5432 user=repl password=password'
trigger_file      = '/var/lib/postgresql/9.6/trigger'
restore_command   = 'cp /var/lib/postgresql/9.6/archive/%f \"%p\"'
EOF"

sudo systemctl start postgresql
sudo systemctl restart postgresql