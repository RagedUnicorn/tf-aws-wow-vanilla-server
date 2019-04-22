#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description Update mangosd.conf.tpl and realmd.conf.tpl then redeploy the configuration

set -euo pipefail

# download configurations from github gists
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'wget -O /home/"${operator_user}"/config/realmd.conf.tpl https://gist.githubusercontent.com/ragedunicorn/fb9e9254a36d8876608696e56b7db2ff/raw/realmd.conf.tpl'
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'wget -O /home/"${operator_user}"/config/mangosd.conf.tpl https://gist.githubusercontent.com/ragedunicorn/fcaf76c924873127e776056271552ef8/raw/mangosd.conf.tpl'
# deploy docker stack
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker deploy --compose-file=/home/"${operator_user}"/docker-compose.stack.yml wow-vanilla-server'
