#!/bin/bash

export RAILS_ENV=test
bundle install
yarn install
bundle exec rake db:test:prepare
bundle exec rake db:pctable
bundle exec rake assets:precompile
bundle exec rake
