#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description Initializing a single node swarm and setting up secrets for mysql container

set -euo pipefail

# get public ip from ec2 metadata service and set as environment variable
echo "PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" | sudo tee -a /etc/environment  -

# creating extra user data
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'echo "${user_extra_data}" | base64 --decode | tee /home/"${operator_user}"/user-data.tar.gz'

sudo tar -zxvf /home/"${operator_user}"/user-data.tar.gz -C /home/"${operator_user}"/

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

# download configurations from github gists
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'wget https://gist.githubusercontent.com/ragedunicorn/fb9e9254a36d8876608696e56b7db2ff/raw/realmd.conf.tpl -P /home/"${operator_user}"/'
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'wget https://gist.githubusercontent.com/ragedunicorn/fcaf76c924873127e776056271552ef8/raw/mangosd.conf.tpl -P /home/"${operator_user}"/'

# setup server data if not already done
sudo mkdir -p data

if [ ! -d /home/"${operator_user}"/data/vmaps ]; then
  sudo wget -P /home/"${operator_user}"/data https://s3.eu-central-1.amazonaws.com/rg-tf-wow-vanilla-data/vmaps.tar.gz
  sudo mkdir /home/"${operator_user}"/data/vmaps
  sudo tar -xzf /home/"${operator_user}"/data/vmaps.tar.gz -C /home/"${operator_user}"/data/vmaps
  sudo rm /home/"${operator_user}"/data/vmaps.tar.gz
fi

if [ ! -d /home/"${operator_user}"/data/mmaps ]; then
  sudo wget -P /home/"${operator_user}"/data https://s3.eu-central-1.amazonaws.com/rg-tf-wow-vanilla-data/mmaps.tar.gz
  sudo mkdir /home/"${operator_user}"/data/mmaps
  sudo tar -xzf /home/"${operator_user}"/data/mmaps.tar.gz -C /home/"${operator_user}"/data/mmaps
  sudo rm /home/"${operator_user}"/data/mmaps.tar.gz
fi

if [ ! -d /home/"${operator_user}"/data/maps ]; then
  sudo wget -P /home/"${operator_user}"/data https://s3.eu-central-1.amazonaws.com/rg-tf-wow-vanilla-data/maps.tar.gz
  sudo mkdir /home/"${operator_user}"/data/maps
  sudo tar -xzf /home/"${operator_user}"/data/maps.tar.gz -C /home/"${operator_user}"/data/maps
  sudo rm /home/"${operator_user}"/data/maps.tar.gz
fi

if [ ! -d /home/"${operator_user}"/data/dbc ]; then
  sudo wget -P /home/"${operator_user}"/data https://s3.eu-central-1.amazonaws.com/rg-tf-wow-vanilla-data/dbc.tar.gz
  sudo mkdir /home/"${operator_user}"/data/dbc
  sudo tar -xzf /home/"${operator_user}"/data/dbc.tar.gz -C /home/"${operator_user}"/data/dbc
  sudo rm /home/"${operator_user}"/data/dbc.tar.gz
fi

# deploy docker stack
echo "${operator_password}" | sudo -S su "${operator_user}" -c 'docker deploy --compose-file=/home/"${operator_user}"/docker-compose.stack.yml wow-vanilla-server'

sudo sed 's/$${operator_password}/${operator_password}/g; s/$${operator_user}/${operator_user}/g' /home/"${operator_user}"/service.sh.tpl > /home/"${operator_user}"/service.sh
sudo chmod +x /home/"${operator_user}"/service.sh

sudo sed 's/$${operator_user}/${operator_user}/g' /home/"${operator_user}"/wow-vanilla-server.service.tpl > /etc/systemd/system/wow-vanilla-server.service

sudo sed 's/$${mysql_app_user}/${mysql_app_user}/g ; s/$${mysql_app_user_password}/${mysql_app_user_password}/g' /home/"${operator_user}"/database-util.sh.tpl > /home/"${operator_user}"/database-util.sh
sudo chmod +x /home/"${operator_user}"/database-util.sh

# enable service on startup
sudo systemctl enable wow-vanilla-server.service
