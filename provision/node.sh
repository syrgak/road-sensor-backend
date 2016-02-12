#!/bin/bash

# Install NodeJS
# ----------------
printf "\n--Install NodeJS...\n"
printf "\n-Installing Node Dependencies...\n"
apt-get -y install python-software-properties python g++ make
add-apt-repository ppa:chris-lea/node.js
apt-get update -y
printf "\n-Installing latest Node...\n"
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
apt-get install -y nodejs

# Grunt Installation & Conf
# -------------
printf "\n\n--Install Grunt...\n"
printf "\n-Installing grunt-cli globally...\n"
npm install -g grunt-cli
