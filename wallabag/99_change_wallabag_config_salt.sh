#!/bin/bash
set -e
SALT='34gAogagAigJaurgbqfdvqQergvqer'
if [ -f /etc/container_environment/WALLABAG_SALT ] ; then
    SALT=`cat /etc/container_environment/WALLABAG_SALT`
fi
sed -i "s/'SALT', '.*'/'SALT', '$SALT'/" /var/www/wallabag/inc/poche/config.inc.php
