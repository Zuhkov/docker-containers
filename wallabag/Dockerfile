# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.16
MAINTAINER Zuhkov <zuhkov@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install locales
RUN locale-gen cs_CZ.UTF-8
RUN locale-gen de_DE.UTF-8
RUN locale-gen en_US.UTF-8
RUN locale-gen es_ES.UTF-8
RUN locale-gen fr_FR.UTF-8
RUN locale-gen it_IT.UTF-8
RUN locale-gen pl_PL.UTF-8
RUN locale-gen pt_BR.UTF-8
RUN locale-gen ru_RU.UTF-8
RUN locale-gen sl_SI.UTF-8
RUN locale-gen uk_UA.UTF-8

# Install wallabag prereqs
RUN add-apt-repository ppa:nginx/stable && \
    apt-get update -q && \
    apt-get install -y nginx sqlite3 php5-cli php5-common php5-sqlite \
      php5-curl php5-fpm php5-json php5-tidy wget unzip gettext
RUN apt-get update -q && \
    apt-get install -y php5-gd

# Configure php-fpm
RUN echo "cgi.fix_pathinfo = 0" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY www.conf /etc/php5/fpm/pool.d/www.conf

RUN mkdir /etc/service/php5-fpm
COPY php5-fpm.sh /etc/service/php5-fpm/run

RUN mkdir /etc/service/nginx
COPY nginx.sh /etc/service/nginx/run

RUN chmod +x /etc/service/php5-fpm/run && \
    chmod +x /etc/service/nginx/run

# Wallabag version
ENV WALLABAG_VERSION 1.9

# Extract wallabag code
ADD https://github.com/wallabag/wallabag/archive/$WALLABAG_VERSION.zip /tmp/wallabag-$WALLABAG_VERSION.zip
COPY vendor.zip /tmp/vendor.zip

RUN mkdir -p /var/www /config
RUN cd /var/www && \
    unzip -q /tmp/wallabag-$WALLABAG_VERSION.zip && \
    mv wallabag-$WALLABAG_VERSION wallabag && \
    cd wallabag && \
    unzip -q /tmp/vendor.zip && \
    sed -i "s/'SALT', '.*'/'SALT', '34gAogagAigJaurgbqfdvqQergvqer'/" /var/www/wallabag/inc/poche/config.inc.default.php
COPY data/poche.sqlite /var/www/wallabag/firstrun/poche.sqlite
RUN cp -r /var/www/wallabag/db/. /var/www/wallabag/firstrun/

COPY 99_change_wallabag_config_salt.sh /etc/my_init.d/99_change_wallabag_config_salt.sh
COPY firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh && \
    rm -f /tmp/wallabag-$WALLABAG_VERSION.zip /tmp/vendor.zip && \
    rm -rf /var/www/wallabag/install && \
    chown -R nobody:users /var/www/wallabag && \
    chmod 755 -R /var/www/wallabag && \
    chown -R nobody:users /config && \
    chmod 755 -R /config

# Configure nginx to serve wallabag app
COPY nginx-wallabag /etc/nginx/sites-available/default

EXPOSE 80/tcp

VOLUME ["/var/www/wallabag/db","/config"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
