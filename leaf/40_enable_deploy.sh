#!/bin/bash

[ -e /etc/logrotate.d/app.disabled ] && mv /etc/logrotate.d/app.disabled /etc/logrotate.d/app

exit 0
