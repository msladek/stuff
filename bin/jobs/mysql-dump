#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

mysql_backup_path="/mnt/backup/mysql"
defaults_file="/etc/mysql/debian.cnf"

databases=$(mysql --defaults-file=${defaults_file} --batch --skip-column-names -e "SHOW DATABASES;" | egrep -v "(information|performance)_schema")
for db in $databases; do
  [ -z "$db" ] && continue
  file="${mysql_backup_path}/${db}.sql.gz"
  rm -f $file
  mysqldump --defaults-file=${defaults_file} \
      --add-drop-table --add-locks --comments --create-options --disable-keys \
      --dump-date --extended-insert --no-create-db --lock-tables \
      --set-charset --quick --routines --events --triggers \
    $db | gzip >$file
done
