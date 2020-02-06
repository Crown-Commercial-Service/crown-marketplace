#!/usr/bin/env bash

bundle exec rails db:migrate

if [ "$APP_RUN_SIDEKIQ" = 'TRUE' ]; then
  bundle exec sidekiq -C ./config/sidekiq.yml -d -L ./log/sidekiq.log -e production
fi

if [ "$APP_RUN_STATIC_TASK" = 'TRUE' ]; then
  bundle exec rails db:static
fi

if [ "$APP_RUN_POSTCODES_IMPORT" = 'TRUE' ]; then
  bundle exec rails db:postcode
fi

if [ "$APP_RUN_NUTS_IMPORT" = 'TRUE' ]; then
  bundle exec rails db:run_postcodes_to_nuts_worker
fi

bundle exec rails server
