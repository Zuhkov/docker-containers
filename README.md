Paperwork
====

Dockerfile for Paperwork with embedded MariaDB (MySQL) Database

Open Source note-taking & archiving alternative to Evernote, Microsoft OneNote & Google Keep

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
cd paperwork
docker build -t zuhkov/paperwork .
```

You can also obtain it via:  

```
docker pull zuhkov/paperwork
```

---
Running
===

Create your Paperwork config directory (which will contain both the properties file and the database) and then launch with the following:

```
docker run -d -v /your-config-location:/config -p 8888:80 zuhkov/paperwork
```

Browse to ```http://your-host-ip:8888``` and login with user and password `paperwork`

---
Credits
===

Paperwork is an open source project and is copyright twostairs

This docker image is built upon the baseimage made by phusion
