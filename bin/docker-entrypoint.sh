#!/usr/bin/env bash

bundle exec rails db:migrate

bundle exec rails db:static

bundle exec sidekiq -d -L log/sidekiq.log -e production

bundle exec rails server

bundle exec rails db:postcode