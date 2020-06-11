#!/usr/bin/env bash

echo 'Starting Postdeploy...'

echo 'Running migrations...'
bundle exec rake db:migrate
