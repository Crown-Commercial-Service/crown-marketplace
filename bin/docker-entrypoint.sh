#!/usr/bin/env bash

bundle exec rails db:drop

bundle exec rails db:setup

bundle exec rails db:migrate

bundle exec rails db:static

bundle exec rails server
