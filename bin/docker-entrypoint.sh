#!/usr/bin/env bash

# because the APP_RUN_SIDEKIQ parameter is defined in /Environment/ccs/cmp and not /Environment/ccs/cmpsidekiq,
# we have to check for it being false, so we can run the rails server, otherwise run sidekiq
if [ "$APP_RUN_SIDEKIQ" = 'FALSE' ]; then
  echo TCPAddr $CLAMAV_SERVER_IP > /etc/clamav/clamd.conf && echo TCPSocket 3310 >> /etc/clamav/clamd.conf

  bundle exec rails db:migrate:ignore_concurrent

  if [ "$APP_RUN_PRECOMPILE_ASSETS" = 'TRUE' ]; then
    bundle exec rake assets:sync
  fi

  if [ "$APP_RUN_RAKE_TASKS" = 'TRUE' ]; then
    bundle exec rails command:run
  fi

  if [ "$APP_RUN_PC_TABLE_MIGRATION" = 'TRUE' ]; then
    bundle exec rails db:pctable
  fi

  if [ "$APP_RUN_POSTCODES_CLEANUP" = 'TRUE' ]; then
    bundle exec rails db:postcode_cleanup
  fi

  if [ "$APP_RUN_POSTCODES_IMPORT" = 'TRUE' ]; then
    bundle exec rails db:postcode
  fi

  if [ "$APP_RUN_NUTS_IMPORT" = 'TRUE' ]; then
    bundle exec rails db:run_postcodes_to_nuts
  fi

  if [ "$APP_RUN_NUTS_IMPORT_IN_BG" = 'TRUE' ]; then
    bundle exec rails db:run_postcodes_to_nuts_worker
  fi

  if [ "$APP_UPDATE_NUTS_NOW" = 'TRUE' ]; then
    bundle exec rails db:update_postcodes_to_nuts_now
  fi

  if [ "$APP_RUN_PROCUREMENTS_CLEANUP" = 'TRUE' ]; then
    bundle exec rails procurements:cleanup
  fi

  bundle exec rails server
else
  bundle exec sidekiq -C ./config/sidekiq.yml -e production
fi
