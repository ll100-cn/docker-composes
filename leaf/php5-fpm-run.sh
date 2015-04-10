#!/bin/bash

exec 2>&1
exec /usr/sbin/php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf
