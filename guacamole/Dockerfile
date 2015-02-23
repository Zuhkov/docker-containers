### Dockerfile for guacamole
### Includes the mysql authentication module preinstalled

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
RUN usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /home nobody && \
    chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db && \
    echo "deb http://mariadb.mirror.iweb.com/repo/5.5/ubuntu `lsb_release -cs` main" \
    > /etc/apt/sources.list.d/mariadb.list

### Don't let apt install docs or man pages
COPY excludes /etc/dpkg/dpkg.cfg.d/excludes
### Install packages and clean up in one command to reduce build size
RUN apt-get update && \
    apt-get install -y --no-install-recommends libcairo2-dev libpng12-dev freerdp-x11 libssh2-1 \
    libfreerdp-dev libvorbis-dev libssl0.9.8 gcc libssh-dev libpulse-dev tomcat7 tomcat7-admin \
    libpango1.0-dev libssh2-1-dev autoconf wget libossp-uuid-dev libtelnet-dev libvncserver-dev \
    build-essential software-properties-common pwgen mariadb-server && \


    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
                            /usr/share/man /usr/share/groff /usr/share/info \
                            /usr/share/lintian /usr/share/linda /var/cache/man && \
    (( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
    (( find /usr/share/doc -empty|xargs rmdir || true ))

### Install the authentication extensions in the classpath folder
### and the client app in the tomcat webapp folder
### Version of guacamole to be installed
ENV GUAC_VER 0.9.5
### Version of mysql-connector-java to install
ENV MCJ_VER 5.1.34
### config directory and classpath directory
RUN mkdir -p /config /var/lib/guacamole/classpath /etc/firstrun

# Tweak my.cnf

RUN sed -i -e 's#\(bind-address.*=\).*#\1 127.0.0.1#g' /etc/mysql/my.cnf && \
    sed -i -e 's#\(log_error.*=\).*#\1 /config/databases/mysql_safe.log#g' /etc/mysql/my.cnf && \
    sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \
    echo '[mysqld]' > /etc/mysql/conf.d/innodb_file_per_table.cnf && \
    echo 'innodb_file_per_table' >> /etc/mysql/conf.d/innodb_file_per_table.cnf

### Install MySQL Authentication Module
RUN cd /tmp && \
    wget -q --span-hosts http://downloads.sourceforge.net/project/guacamole/current/extensions/guacamole-auth-mysql-${GUAC_VER}.tar.gz && \
    tar -zxf guacamole-auth-mysql-$GUAC_VER.tar.gz && \
    mv -f `find . -type f -name '*.jar'` /var/lib/guacamole/classpath && \
    mv -f guacamole-auth-mysql-$GUAC_VER/schema/*.sql /root &&\
    rm -Rf /tmp/*

### Install dependancies for mysql authentication module
RUN cd /tmp && \
    wget -q --span-hosts http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MCJ_VER}.tar.gz && \
    tar -zxf mysql-connector-java-$MCJ_VER.tar.gz && \
    mv -f `find . -type f -name '*.jar'` /var/lib/guacamole/classpath && \
    rm -Rf /tmp/*

### Install precompiled client webapp
RUN cd /var/lib/tomcat7/webapps && \
    rm -Rf ROOT && \
    wget -q --span-hosts http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-${GUAC_VER}.war && \
    ln -s guacamole-$GUAC_VER.war ROOT.war && \
    ln -s guacamole-$GUAC_VER.war guacamole.war

### Compile and install guacamole server
RUN cd /tmp && \
    wget -q --span-hosts http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-${GUAC_VER}.tar.gz && \
    tar -zxf guacamole-server-$GUAC_VER.tar.gz && \
    cd guacamole-server-$GUAC_VER && \
    ./configure --with-init-dir=/etc/init.d && \
    make && \
    make install && \
    update-rc.d guacd defaults && \
    ldconfig && \
    rm -Rf /tmp/*

### Compensate for GUAC-513
RUN ln -s /usr/local/lib/freerdp/guacsnd.so /usr/lib/x86_64-linux-gnu/freerdp/ && \
    ln -s /usr/local/lib/freerdp/guacdr.so /usr/lib/x86_64-linux-gnu/freerdp/

### Configure Service Startup
COPY rc.local /etc/rc.local
COPY mariadb.sh /etc/service/mariadb/run
COPY firstrun.sh /etc/my_init.d/firstrun.sh
COPY configfiles/. /etc/firstrun/
RUN chmod a+x /etc/rc.local && \
    chmod +x /etc/service/mariadb/run && \
    chmod +x /etc/my_init.d/firstrun.sh && \
    chown -R nobody:users /config && \
    chown -R nobody:users /var/log/mysql* && \
    chown -R nobody:users /var/lib/mysql && \
    chown -R nobody:users /etc/mysql && \
    chown -R nobody:users /var/run/mysqld

EXPOSE 8080

VOLUME ["/config"]

### END
### To make this a persistent guacamole container, you must map /config of this container
### to a folder on your host machine.
###
