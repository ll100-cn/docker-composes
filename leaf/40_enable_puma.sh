#!/bin/bash

rm -f /etc/service/nginx/down
rm -f /etc/service/puma/down
rm -f /etc/service/puma/log/down
rm -f /etc/service/nginx-log-forwarder/down
mv /etc/logrotate.d/nginx.disabled /etc/logrotate.d/nginx

exit 0
