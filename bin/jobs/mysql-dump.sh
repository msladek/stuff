#!/bin/bash
mysql_backup_path="/mnt/backup/mysql"
defaults_file="/etc/mysql/debian.cnf"

# make sure pipe "mysqldump | gzip" fails correctly
set -o pipefail
error_log="${mysql_backup_path}/error.log"
databases=$(mysql --defaults-file=${defaults_file} --batch --skip-column-names -e "SHOW DATABASES;" | egrep -v "(information|performance)_schema")
for db in $databases; do
  if [ "$db" ]; then
    file="${mysql_backup_path}/${db}.sql.gz"
    rm -f $file
    mysqldump --defaults-file=${defaults_file} \
      --add-drop-table --add-locks --comments --create-options --disable-keys \
      --dump-date --extended-insert --no-create-db --lock-tables \
      --set-charset --quick --routines --events --triggers \
      $db | gzip >$file 2>$error_log
    if [ $? != 0 ]; then
      echo -e "Subject: [IMPORTANT] MySQL dump fault\n\n`hostname`\nsee $error_log" | msmtp root@sladek.co
    fi
  fi
done
