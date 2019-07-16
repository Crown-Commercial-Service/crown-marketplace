#!/usr/bin/env bash

bundle exec rails db:migrate

bundle exec rails db:static
bundle exec rails db:postcode

bundle exec sidekiq -C config/sidekiq.yml -d -L log/sidekiq.log -e production

bundle exec rails server
