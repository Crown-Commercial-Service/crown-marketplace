#!/usr/bin/env bash

bundle exec rails db:migrate

if [ "$APP_RUN_SIDEKIQ" = 'true' ]; then
  bundle exec sidekiq -C ./config/sidekiq.yml -d -L ./log/sidekiq.log -e production
fi

if [ "$APP_RUN_STATIC_TASK" = 'true' ]; then
  bundle exec rails db:static
fi

if [ "$APP_RUN_POSTCODES_IMPORT" = 'true' ]; then
  bundle exec rails db:postcode
fi

if [ "$APP_RUN_NUTS_IMPORT" = 'true' ]; then
  bundle exec rails db:run_postcodes_to_nuts_worker
fi

bundle exec rails server
