#!/usr/bin/env bash

bundle exec rails db:migrate

bundle exec rails db:static

bundle exec sidekiq

bundle exec rails server
