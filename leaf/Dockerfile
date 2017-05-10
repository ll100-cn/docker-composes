FROM sunteya/passenger:20170510-ruby23

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
RUN apt update # 20170510
RUN apt install -y ghostscript libav-tools

# Passenger and Nginx
COPY nginx-site-default.conf /etc/nginx/sites-available/default
RUN mv /etc/logrotate.d/nginx /etc/logrotate.d/nginx.disabled \
 && mv /etc/logrotate.d/app /etc/logrotate.d/app.disabled \
 && touch /etc/service/nginx/down \
 && touch /etc/service/nginx-log-forwarder/down

# Role
COPY 40_enable_role_service.sh /etc/my_init.d/
RUN passwd -u app

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
