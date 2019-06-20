#!/bin/bash

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
apt update
apt-get install -y build-essential
apt install -y postgresql-11-postgis-2.5
sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/11/main/postgresql.conf
sudo cp /etc/postgresql/{10,11}/main/pg_hba.conf
sudo service postgresql stop
service postgresql start 11
sudo -u postgres createuser --superuser root; sudo -u postgres createdb root
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
alias node=nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'
apt update
apt install --no-install-recommends yarn
PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
curl -OLk https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
tar xvjf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs
rm -rf $PHANTOM_JS