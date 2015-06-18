# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-customizable:0.9.15

RUN apt-get update # 20150518
RUN /pd_build/utilities.sh
RUN /pd_build/ruby2.2.sh

RUN usermod -a -G docker_env app
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
EXPOSE 22

RUN apt-get install -y rsync
RUN apt-get install -y ghostscript

# Timezone
RUN echo Asia/Shanghai > /etc/timezone
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# SSH
RUN sed 's/#ClientAliveInterval 0/ClientAliveInterval 60/' -i /etc/ssh/sshd_config


# App
RUN npm install -g bower

# Passenger and Nginx
RUN sed 's/www-data/app/' -i /etc/nginx/nginx.conf
ADD nginx-passenger.conf /etc/nginx/conf.d/passenger.conf
RUN rm -f /etc/nginx/sites-available/default
ADD nginx-site-default.conf /etc/nginx/sites-available/default
RUN mv /etc/logrotate.d/nginx /etc/logrotate.d/nginx.disabled
ADD logrotate-app.conf /etc/logrotate.d/app.disabled
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

