FROM sunteya/passenger:20171017-ruby24

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
#RUN npm install -g yarn
RUN apt update # 20171017
RUN apt install -y ghostscript libav-tools

# Passenger and Nginx
COPY nginx-passenger.conf /etc/nginx/conf.d/passenger.conf
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
