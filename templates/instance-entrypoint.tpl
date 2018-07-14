#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description Initializing a single node swarm and setting up secrets for mysql container

# abort when trying to use unset variable
set -euo pipefail

# init single docker swarm
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker swarm init'

# init secrets for mysql container
echo "$(date) [INFO]: Initializing docker secrets"
echo "${mysql_root_password}" | echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker secret create com.ragedunicorn.mysql.root_password -'
echo "${mysql_app_user}" | echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker secret create com.ragedunicorn.mysql.app_user -'
echo "${mysql_app_user_password}" | echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker secret create com.ragedunicorn.mysql.app_user_password -'
