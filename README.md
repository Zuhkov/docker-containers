Paperwork
====
Based on existing work of Zuhkov <zuhkov@gmail.com>. Compared to the original work this contains a more up-to-date version of paperwork and it's dependencies.

---

Image contains paperwork, an open source note-taking alternative to Evernote. It also includes the needed MariaDB.

---
Running
===
The configuration as well as the persisten data will be stored int the ```/configuration``` folder. Paperwork will be exposed on port 80. Therefore run:

```
docker run -d -v /persistence-path:/config -p 80:80 nephelo/paperwork
```

to start paperwork. To run the setup open ```database.php``` in the ```/configuration``` folder. Line 61 should contain the randomly created database password.

Browse to ```http://localhost:80``` and login with user and password `paperwork`

---
Author
===
This docker image is based on the work of:
Zuhkov <zuhkov@gmail.com>

Credits
===
Paperwork is an open source project and is copyright twostairs
This docker image is built upon the baseimage made by phusion
This docker image is based on the work of Zuhkov <zuhkov@gmail.com>
