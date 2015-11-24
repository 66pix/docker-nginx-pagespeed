FROM debian:jessie

ENV NGINX_VERSION 1.9.6
ENV NPS_VERSION=1.9.32.10

RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update
RUN apt-get -y install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip wget

RUN cd /usr/src \
   && wget -q https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip \
   && unzip -qq release-${NPS_VERSION}-beta.zip \
   && cd ngx_pagespeed-release-${NPS_VERSION}-beta/ \
   && wget -q https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz \
   && tar --no-same-owner -xzf ${NPS_VERSION}.tar.gz  # extracts to psol/

RUN cd /usr/src \
    && wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar --no-same-owner -xzf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION}/ \
    && ./configure --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta \
    && make \
    && make install

RUN rm -rf /usr/src

RUN ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx
RUN ln -s /usr/local/nginx/logs /var/logs

RUN mkdir -p /var/pagespeed/cache
RUN chown -R www-data:www-data /var/pagespeed/cache

RUN apt-get remove -y build-essential unzip wget --purge
RUN apt-get autoremove -y --purge

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

