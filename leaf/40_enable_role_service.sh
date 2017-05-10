#!/bin/bash

if [[ $ROLE == *"passenger"* ]]; then
	rm -f /etc/service/nginx/down
	rm -f /etc/service/nginx-log-forwarder/down
	mv /etc/logrotate.d/nginx.disabled /etc/logrotate.d/nginx
fi

if [[ $ROLE == *"sidekiq"* ]]; then
	rm -f /etc/service/sidekiq/down
	rm -f /etc/service/sidekiq-monitor/down
fi

if [[ $ROLE == *"sftp"* ]]; then
	[ -n $APP_PASSWORD ] && echo "app:$APP_PASSWORD" | chpasswd
fi

if [[ $ROLE == *"deploy"* ]]; then
	[ -e /etc/logrotate.d/app.disabled ] && mv /etc/logrotate.d/app.disabled /etc/logrotate.d/app
fi

exit 0
