Guacamole
====

Dockerfile for Guacamole 0.9.5 with embedded MariaDB (MySQL) Authentication

Guacamole is a clientless remote desktop gateway. It supports standard protocols like VNC and RDP.

---
Author
===

Zuhkov <zuhkov@gmail.com>

---
Building
===

Build from docker file:

```
git clone git@github.com:Zuhkov/docker-containers.git
cd guacamole
docker build -t zuhkov/guacamole .
```

You can also obtain it via:  

```
docker pull zuhkov/guacamole
```

---
Running
===

Create your guacamole config directory (which will contain both the properties file and the database) and then launch with the following:

```
docker run -d -v /your-config-location:/config -p 8080:8080 zuhkov/guacamole
```

Browse to ```http://your-host-ip:8080``` and login with user and password `guacadmin`

---
Credits
===

Guacamole is an open source project and is copyright Glyptodon LLC

This docker image is built upon the baseimage made by phusion and forked from hall/guacamole
