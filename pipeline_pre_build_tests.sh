#!/bin/bash

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
apt update
apt-get install -y build-essential
apt-get install -y ruby ruby-dev
apt install -y postgresql-9.6-postgis-2.3
service postgresql start 9.6
sudo -u postgres createuser --superuser root; sudo -u postgres createdb root
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
alias node=nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'
apt update
apt install --no-install-recommends yarn
