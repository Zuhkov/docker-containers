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
  
  echo "Preparing LDAP configuration"
  cp /var/www/paperwork/frontend/app/config/ldap.php /config/ldap.php
  chown nobody:users /config/ldap.php
  
  echo "Preparing storage folder"
  cp -r /var/www/paperwork/frontend/app/storage/ /config/storage/
  rm -r /var/www/paperwork/frontend/app/storage/*
fi

ln -s /config/storage /var/www/paperwork/frontend/app/storage
ln -s /config/database.php /var/www/paperwork/frontend/app/config/database.php
ln -s /config/ldap.php /var/www/paperwork/frontend/app/config/ldap.php
chown nobody:users -R /var/www/paperwork
chmod 755 -R /var/www/paperwork
