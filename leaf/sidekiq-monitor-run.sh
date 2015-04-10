#!/bin/bash

while inotifywait -e attrib /home/app/current/tmp/restart.txt; do
	sv stop sidekiq
	sv start sidekiq
done
