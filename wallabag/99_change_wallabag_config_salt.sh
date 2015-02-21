#!/bin/bash
set -e
if [ -f /etc/container_environment/WALLABAG_SALT ] ; then
    OLDHASH=`echo -n wallabagwallabag34gAogagAigJaurgbqfdvqQergvqer | sha1sum | awk '{print $1}'`
    SALT=`cat /etc/container_environment/WALLABAG_SALT`
    NEWHASH=`echo -n wallabagwallabag$SALT | sha1sum | awk '{print $1}'`
    sqlite3 /var/www/wallabag/db/poche.sqlite "UPDATE users SET password='$NEWHASH' WHERE password='$OLDHASH'"
    sed -i "s/'SALT', '.*'/'SALT', '$SALT'/" /config/config.inc.php
fi
