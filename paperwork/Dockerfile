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

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db && \
    echo "deb http://mariadb.mirror.iweb.com/repo/5.5/ubuntu `lsb_release -cs` main" \
    > /etc/apt/sources.list.d/mariadb.list

RUN curl -sL https://deb.nodesource.com/setup | sudo bash -

# Install Paperwork prereqs
RUN add-apt-repository ppa:nginx/stable && \
    apt-get update -q && \
    apt-get install -y --no-install-recommends mariadb-server nginx php5-cli php5-common \
      php5-curl php5-fpm php5-tidy wget unzip software-properties-common pwgen \
       git php5-mysql php5-gd php5-mcrypt nodejs

# Configure php-fpm
#RUN echo "cgi.fix_pathinfo = 0" >> /etc/php5/fpm/php.ini
RUN echo "extension=mcrypt.so" >> /etc/php5/fpm/php.ini && \
    echo "extension=mcrypt.so" >> /etc/php5/cli/php.ini && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

# Tweak my.cnf
RUN sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
    sed -i -e 's#\(log_error.*=\).*#\1 /config/databases/mysql_safe.log#g' /etc/mysql/my.cnf && \
    sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
    echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
    echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf

COPY www.conf /etc/php5/fpm/pool.d/www.conf

RUN mkdir /etc/service/php5-fpm
COPY php5-fpm.sh /etc/service/php5-fpm/run

RUN mkdir /etc/service/nginx
COPY nginx.sh /etc/service/nginx/run

RUN chmod +x /etc/service/php5-fpm/run && \
    chmod +x /etc/service/nginx/run

# Move to pulling specific versions once Paperwork has them
#ENV PAPERWORK_VERSION 1.0

# Install composer
RUN cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN mkdir -p /var/www /config/databases /etc/firstrun
RUN cd /var/www && \
    git clone https://github.com/twostairs/paperwork.git && \
    cd ./paperwork/frontend/ && \
    composer install && \
    wget https://www.npmjs.org/install.sh && \
    bash ./install.sh && \
    npm install -g gulp && \
    npm install && \
    gulp

COPY firstrun.sh /etc/my_init.d/firstrun.sh
COPY mariadb.sh /etc/service/mariadb/run
COPY database.php /etc/firstrun/database.php
RUN chmod +x /etc/my_init.d/firstrun.sh && \
    chmod +x /etc/service/mariadb/run && \
    chown -R nobody:users /var/www/paperwork && \
    chmod 755 -R /var/www/paperwork && \
    chown -R nobody:users /config && \
    chmod 755 -R /config && \
    chown -R nobody:users /var/log/mysql* && \
    chown -R nobody:users /var/lib/mysql && \
    chown -R nobody:users /etc/mysql && \
    chown -R nobody:users /var/run/mysqld && \
    rm /var/www/paperwork/frontend/app/config/database.php

# Configure nginx to serve Paperwork app
COPY nginx-paperwork /etc/nginx/sites-available/default

EXPOSE 80/tcp 3306

VOLUME ["/config"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
