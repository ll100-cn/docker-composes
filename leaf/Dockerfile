FROM sunteya/puma:20181115-ruby25

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
RUN apt update # 20190109
RUN apt install -y ghostscript ffmpeg
RUN apt install -y libxtst6 libnss3 libxss1 libgconf-2-4 libatk1.0 libxtst6 libgtk-3-0 libatk-bridge2.0-dev
RUN apt install -y fonts-noto-cjk
COPY policy.xml /etc/ImageMagick-6/policy.xml
RUN apt install -y link-grammar liblink-grammar-dev

# Passenger and Nginx
COPY nginx-site-default.conf /etc/nginx/sites-available/default
RUN echo "" > /etc/nginx/passenger.conf
RUN mv /etc/logrotate.d/nginx /etc/logrotate.d/nginx.disabled \
 && mv /etc/logrotate.d/app /etc/logrotate.d/app.disabled \
 && touch /etc/service/nginx/down \
 && touch /etc/service/nginx-log-forwarder/down \
 && touch /etc/service/puma/down \
 && touch /etc/service/puma/log/down

# Allow app can login for SSH
RUN passwd -u app

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
