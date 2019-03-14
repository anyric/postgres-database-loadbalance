#!/bin/bash
set -ex
set -o pipefail

/etc/init.d/postgresql stop

echo "archive_command = 'cp %p /var/lib/postgresql/9.6/archive/%f'" >> /etc/postgresql/9.6/main/postgresql.conf
mkdir /var/lib/postgresql/9.6/archive
chown postgres.postgres /var/lib/postgresql/9.6/archive

rm -rf /var/lib/postgresql/9.6/main/*
PGPASSWORD="password"
pg_basebackup -h postgres-master -D /var/lib/postgresql/9.6/main -U repl --xlog-method=stream

bash -c "cat <<EOF> /var/lib/postgresql/9.6/main/recovery.conf
standby_mode      = 'on'
primary_conninfo  = 'host=postgres-master port=5432 user=repl password=password'
trigger_file      = '/var/lib/postgresql/9.6/trigger'
restore_command   = 'cp /var/lib/postgresql/9.6/archive/%f \"%p\"'
EOF"

/etc/init.d/postgresql start
/etc/init.d/postgresql restart

