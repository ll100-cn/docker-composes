FROM sunteya/puma:20200211-ruby26

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
RUN apt update # 20200211
RUN apt install -y yasm
RUN apt install -y wget curl
RUN curl -L https://gist.github.com/Lupeipei/1e4f4470880b44c6c3e52a7e4ce965b3/raw/0b3b83755e3ca7839eb4c73b106a2fb13b1998b4/install_ffmpeg_libfdkaac.sh | bash
RUN apt install -y ghostscript
RUN apt install -y libxtst6 libnss3 libxss1 libgconf-2-4 libatk1.0 libxtst6 libgtk-3-0 libatk-bridge2.0-dev
RUN apt install -y fonts-noto-cjk
COPY policy.xml /etc/ImageMagick-6/policy.xml
RUN apt install -y link-grammar liblink-grammar-dev
RUN apt install -y libvips

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
