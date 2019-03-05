#!/usr/bin/env bash

bundle exec rails db:static

bundle exec rails db:migrate

bundle exec rails server
