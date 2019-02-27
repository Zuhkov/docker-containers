Observium
====

Dockerfile for Observium with embedded MariaDB (MySQL) Database

Observium is an autodiscovering network monitoring platform supporting a wide range of hardware platforms and operating systems

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
cd observium
docker build -t zuhkov/observium .
```

You can also obtain it via:  

```
docker pull zuhkov/observium
```

---
Running
===

Create your Observium config directory (which will contain both the properties file and the database) and then directories for the logs and RRDs and then launch with the following:

```
docker run -d -v /your-config-location:/config -v /path-to-logs:/opt/observium/logs -v /path-to-rrds:/opt/observium/rrd -p 8668:8668 zuhkov/observium
```
To set the timezone for Observium, pass in a valid value as an environment variable:

```
docker run -d -v /your-config-location:/config -v /path-to-logs:/opt/observium/logs -v /path-to-rrds:/opt/observium/rrd -e TZ="America/Chicago" -p 8668:8668 zuhkov/observium
```
If you do not specify a timezone, the timezone will be set to UTC.

Browse to ```http://your-host-ip:8668``` and login with user and password `observium`

---
Credits
===

Observium Community is an open source project and is copyright Observium Limited

This docker image is built upon the baseimage made by phusion
