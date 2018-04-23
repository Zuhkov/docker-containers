#!/bin/bash

# Check if PHP database config exists. If not, copy in the default config
if [ -f /config/database.php ]; then
  echo "Using existing PHP database config file."
else
  echo "Loading PHP config from default."
  mkdir -p /config/databases
  cp /etc/firstrun/database.php /config/database.php
  chown nobody:users /config/database.php
  PW=$(pwgen -1snc 32)
  sed -i -e 's/some_password/'$PW'/g' /config/database.php
fi

ln -s /config/database.php /var/www/paperwork/frontend/app/config/database.php
chown nobody:users -R /var/www/paperwork
chmod 755 -R /var/www/paperwork
