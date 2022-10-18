#!/bin/bash

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
apt-get update
apt-get install -y build-essential

apt-get -y install postgis postgresql-10-postgis-2.4
service postgresql start 10

sudo -u postgres createuser --superuser root
sudo -u postgres createdb root

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
alias node=nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'
apt-get update
apt-get install -y --no-install-recommends yarn

PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
curl -OLk https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
wget --quiet https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
tar xvjf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS /usr/local/share
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
rm -rf $PHANTOM_JS