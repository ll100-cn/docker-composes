FROM sunteya/passenger:20260601-ruby34

# SSH
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# App
RUN apt update # 2020-01-04.1
RUN apt install -y yasm
RUN apt install -y wget curl
RUN apt remove -y imagemagick
RUN curl -L https://gist.githubusercontent.com/Guoxweii/bb51c6b49ed60ce2c0eb78a6abd74d7a/raw/7126d9a40641eea36d3f809eb77526d141376840/imagemagick_support_heic_format.sh | bash
RUN curl -L https://gist.githubusercontent.com/Guoxweii/f19d691f79af94dd8fed074cfa0328a3/raw/03750d3825238d05d7dd7c410e99be7be0635385/install_ffmpeg_with_fdk_aac.sh | bash
RUN apt install -y ghostscript

RUN apt update
RUN apt install -y libxtst6 libnss3 libxss1 libxtst6 libgtk-3-0 libatk-bridge2.0-dev
RUN apt install -y libgbm1 libasound2t64
RUN apt install -y fonts-noto-cjk
COPY policy.xml /etc/ImageMagick-6/policy.xml
RUN apt install -y link-grammar liblink-grammar-dev
RUN apt install -y libvips
RUN apt install -y unzip
RUN apt install -y zip
RUN curl -L https://gist.github.com/Guoxweii/d5ed9a4b15344697b7568f2a9baa04e4/raw/3c2b15d74d798659019cae348504ec299e6d2003/install_mediainfo.sh | bash


# Passenger and Nginx
COPY nginx-site-default.conf /etc/nginx/sites-available/puma
RUN echo "" > /etc/nginx/passenger.conf
RUN mv /etc/logrotate.d/nginx /etc/logrotate.d/nginx.disabled \
 && mv /etc/logrotate.d/app /etc/logrotate.d/app.disabled \
 && touch /etc/service/nginx/down \
 && touch /etc/service/nginx-log-forwarder/down \
 && touch /etc/service/puma/down \
 && touch /etc/service/puma/log/down

# Allow app can login for SSH
RUN passwd -u app

# Set Environment
ENV OPENSSL_CONF=/etc/ssl

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
