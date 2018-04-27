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
  cp /var/www/paperwork/frontend/app/config/auth.php /config/auth.php
  chown nobody:users /config/ldap.php
  chown nobody:users /config/auth.php

  echo "Preparing storage folder"
  cp -r /var/www/paperwork/frontend/app/storage/ /config/storage/
fi

echo "Creating symlinks"
#rm /var/www/paperwork/frontend/app/config/database.php
ln -s /config/database.php /var/www/paperwork/frontend/app/config/database.php

rm /var/www/paperwork/frontend/app/config/ldap.php
ln -s /config/ldap.php /var/www/paperwork/frontend/app/config/ldap.php

rm /var/www/paperwork/frontend/app/config/auth.php
ln -s /config/auth.php /var/www/paperwork/frontend/app/config/auth.php

if [ ! -L /var/www/paperwork/frontend/app/storage ]; then
  rm -r /var/www/paperwork/frontend/app/storage
  ln -s /config/storage/ /var/www/paperwork/frontend/app/
fi

chown nobody:users -R /var/www/paperwork
chmod 755 -R /var/www/paperwork
