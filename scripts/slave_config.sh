#!/bin/bash
set -ex
set -o pipefail

sudo systemctl stop postgresql
rm -rf /var/lib/postgresql/10.4/main/*

pg_basebackup --xlog-method=stream -D /var/lib/postgresql/10.4/main/ -U repl -h postgres-master

sudo bash -c 'cat <<EOF> /var/lib/postgresql/9.4/main/recovery.conf
standby_mode = 'on'
primary_conninfo = 'host=postgres-master port=5432 user=repl password=password'
trigger_file = '/tmp/failover.trigger'
EOF'
}

chmod -R g-rwx,o-rwx /var/lib/postgresql/10.4/main/ ; chown -R postgres.postgres /var/lib/postgresql/10.4/main/
 
sudo systemctl restart postgresql
