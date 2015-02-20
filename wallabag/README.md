# wallabag

Dockerfile used to build a wallabag docker image.

This was forked from bobmaerten/docker-wallabag to eliminate the script for persistence in favor of a volume and to better conform to best practices for unRAID Docker.

## Usage from index.docker.io

    ID=$(sudo docker run -p 7070:80 -d zuhkov/wallabag:latest /sbin/my_init)

Then head your browser to http://localhost:7070 and enjoy a fresh wallabag install.

Login with Username and password `wallabag`. Don't forget to change your password!

When you're finished, just stop the docker container:

    sudo docker stop $ID

Check the [phusion/baseimage](https://github.com/phusion/baseimage-docker) documentation for all kind of options and switches.

## Persistence of the database and PHP config file

Persistence is accomplished with a Volume containing the folder with the sqlite database and a Volume for the PHP config file.

    docker run -p 7070:80/tcp -d -v /where/you/want/to/store/db:/var/www/wallabag/db -v /where/you/want/to/store/config:/config zuhkov/wallabag /sbin/my_init

## Using ENV variable to pass SALT value in config file

You can specify a `--env WALLABAG_SALT=<insert salt value here>` in the docker run command in order to fix the salt value in the wallabag config file on container startup.
Example:

    sudo docker run -p 7070:80 -d --env WALLABAG_SALT=34gAogagAigJaurgbqfdvqQergvqer zuhkov/wallabag:latest /sbin/my_init

NOTE: This option should not be used until an update is made to the sqlite database to update the temporary password hash to use the new SALT. Utilizing this option will not allow you to login using the specified username and password above.

## building from Dockerfile

    sudo docker build -t zuhkov/wallabag .

# Credits

wallabag is an open source project created by @nicosomb

This docker image is built upon the baseimage made by phusion and forked from bobmaerten/docker-wallabag
