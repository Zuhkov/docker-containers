#!/bin/bash

# Check if properties file  exists. If not, copy in the starter database
if [ -f /config/guacamole/guacamole.properties ]; then
  echo "Using existing properties file."
else
  echo "Creating properties from template."
  mkdir -p /config/databases /config/guacamole
  cp -R /etc/firstrun/. /config/guacamole
fi

ln -s /config/guacamole /usr/share/tomcat7/.guacamole
chown nobody:users -R /config/
chmod 755 -R /config/
