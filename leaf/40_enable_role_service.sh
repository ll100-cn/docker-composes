#!/bin/bash

if [[ $ROLE == *"nginx"* ]]; then
	rm -f /etc/service/php5-fpm/down
	rm -f /etc/service/nginx/down
fi

if [[ $ROLE == *"sidekiq"* ]]; then
	rm -f /etc/service/sidekiq/down
	rm -f /etc/service/sidekiq-monitor/down
fi

if [[ $ROLE == *"sftp"* ]]; then
	[ -n $APP_PASSWORD ] && echo "app:$APP_PASSWORD" | chpasswd
fi
