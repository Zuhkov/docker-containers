#!/bin/bash

# Check if database exists. If not, copy in the starter database
if [ -f /var/www/wallabag/db/poche.sqlite ]; then
  echo "Using existing sqlite database file."
else
  echo "Creating config from template."
  cp -r /var/www/wallabag/firstrun/. /var/www/wallabag/db/
  chown www-data:www-data -R /var/www/wallabag/db
  chmod 755 -R /var/www/wallabag/db
fi

# Check if PHP config exists. If not, copy in the default config
if [ -f /var/www/wallabag/inc/poche/config.inc.php ]; then
  echo "Using existing PHP config file."
else
  echo "Loading PHP config from default."
  mkdir /config
  cp /var/www/wallabag/inc/poche/config.inc.default.php /config/config.inc.php
fi

ln -s /config/config.inc.php /var/www/wallabag/inc/poche/config.inc.php
chown www-data:www-data -R /var/www/wallabag/inc/poche
chmod 755 -R /var/www/wallabag/inc/poche
