#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description Create backup of characters database or restore the database with a backup
# ./database-util.sh backup [backup location] - ./database-util.sh retore [path to backup]
# Note: Backup location should always have a trailing slash

set -eo pipefail

operation=$1
backup=$2

function create_characters_database_backup {
  local container_id
  container_id=$(sudo docker ps -qf "name=wow-vanilla-server_wow-vanilla-database")
  local timestamp
  timestamp=$(date +%s)

  echo "$(date) [INFO]: Creating database backup..."

  sudo docker exec "${container_id}" /usr/bin/mysqldump -u"${mysql_app_user}" -p"${mysql_app_user_password}" characters  | sudo tee "${backup}"characters_"${timestamp}".sql

  if [ $? -ne 0 ]; then
    echo "$(date) [ERROR]: Failed to create characters backup"
    exit 1
  else
    echo "$(date) [INFO]: Finished creating characters backup"
  fi
}

function restore_characters_database {
  local container_id
  container_id=$(sudo docker ps -qf "name=wow-vanilla-server_wow-vanilla-database")

  cat "${backup}" | sudo docker exec -i "${container_id}" /usr/bin/mysql -u"${mysql_app_user}" -p"${mysql_app_user_password}" characters

  if [ $? -ne 0 ]; then
    echo "$(date) [ERROR]: Failed to restore characters database"
    exit 1
  else
    echo "$(date) [INFO]: Finished restoring characters database"
  fi
}

if [ -z "${operation+x}" ] && [ -z "${backup+x}" ]; then
  echo "$(date) [ERROR]: Missing required parameter"
  exit 1
else
  if [ "${operation}" = "backup" ]; then
    create_characters_database_backup
  elif [ "${operation}" = "restore" ]; then
    restore_characters_database
  else
    echo "$(date) [ERROR]: Invalid operation. Valid operations are 'restore' and 'backup'"
  fi
fi
