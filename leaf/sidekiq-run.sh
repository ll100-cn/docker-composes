#!/bin/bash

cd /home/app/current
exec 2>&1
exec chpst -u app bundle exec sidekiq -e production -P tmp/pids/sidekiq.pid

