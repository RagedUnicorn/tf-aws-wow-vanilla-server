#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description Initializing a single node swarm and setting up secrets for mysql container

# abort when trying to use unset variable
set -euo pipefail

# get public ip from ec2 metadata service and set as environment variable
echo "PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" | sudo tee -a /etc/environment  -

# enable experimental for docker
echo "{\"experimental\": true }" | sudo tee /etc/docker/daemon.json

# restart docker daemon
sudo service docker restart

# init single docker swarm
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker swarm init'

# init secrets for mysql container
echo "$(date) [INFO]: Initializing docker secrets"
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'echo "${mysql_root_password}" | docker secret create com.ragedunicorn.mysql.root_password -'
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'echo "${mysql_app_user}" | docker secret create com.ragedunicorn.mysql.app_user -'
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'echo "${mysql_app_user_password}" | docker secret create com.ragedunicorn.mysql.app_user_password -'

# creating stack file
echo "${docker_compose_content}"
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'echo "${docker_compose_content}" | base64 --decode | tee /home/"${operator_user}"/docker-compose.stack.yml'

# deploy docker stack
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker deploy --compose-file=/home/"${operator_user}"/docker-compose.stack.yml wow-vanilla-server'
