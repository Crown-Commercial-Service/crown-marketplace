#!/usr/bin/env bash

bundle exec rails db:migrate

bundle exec rails db:static
# temporarily disabling this as it's giving AccessDenied from S3
#bundle exec rails db:postcode
bundle exec rails db:importpostcoderegion

bundle exec sidekiq -C ./config/sidekiq.yml -d -L ./log/sidekiq.log -e production if ENV['APP_RUN_SIDEKIQ'].present?

bundle exec rails server
