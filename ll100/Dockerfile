FROM jwilder/nginx-proxy:latest

RUN apt-get update \
 && apt-get install -y patch \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  # 20150408

ADD nginx-tmpl.patch /app/nginx-tmpl.patch
RUN cd /app && patch < /app/nginx-tmpl.patch

