FROM sunteya/passenger:20170117-ruby23

RUN apt-get update # 20170125

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
RUN apt-get install -y ghostscript
RUN apt-get install -y libav-tools

# Passenger and Nginx
RUN rm -f /etc/nginx/sites-available/default
ADD nginx-site-default.conf /etc/nginx/sites-available/default
RUN mv /etc/logrotate.d/nginx /etc/logrotate.d/nginx.disabled
RUN mv /etc/logrotate.d/app /etc/logrotate.d/app.disabled
RUN touch /etc/service/nginx/down
RUN touch /etc/service/nginx-log-forwarder/down

# Sidekiq
RUN apt-get install -y inotify-tools
RUN mkdir -p /etc/service/sidekiq-monitor
RUN touch /etc/service/sidekiq-monitor/down
ADD sidekiq-monitor-run.sh /etc/service/sidekiq-monitor/run
RUN chmod +x /etc/service/sidekiq-monitor/run

RUN mkdir -p /etc/service/sidekiq
RUN touch /etc/service/sidekiq/down
ADD sidekiq-run.sh /etc/service/sidekiq/run
RUN chmod +x /etc/service/sidekiq/run
ADD sidekiq-finish.sh /etc/service/sidekiq/finish
RUN chmod +x /etc/service/sidekiq/finish

# Role
ADD 40_enable_role_service.sh /etc/my_init.d/40_enable_role_service.sh
RUN chmod +x /etc/my_init.d/40_enable_role_service.sh
RUN passwd -u app

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
