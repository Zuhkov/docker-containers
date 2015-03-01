#!/bin/bash
start_mysql(){
    /usr/bin/mysqld_safe --datadir=/config/databases > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
        sleep 1
    done
}

# If databases do not exist, create them
if [ -f /config/databases/paperwork/users.ibd ]; then
  echo "Database exists."
else
  echo "Initializing Data Directory."
  /usr/bin/mysql_install_db --datadir=/config/databases >/dev/null 2>&1
  echo "Installation complete."
  start_mysql
  echo "Creating user and database."
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS paperwork DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
  PW=$(cat /config/database.php | grep -m 1 "'password'\s\s=>\s" | sed -r 's/.*(.{34})/\1/;s/.{2}$//')
  mysql -uroot -e "CREATE USER 'paperwork'@'localhost' IDENTIFIED BY '$PW'"
  echo "Database created. Granting access to 'paperwork' user for localhost."
  mysql -uroot -e "GRANT ALL PRIVILEGES ON paperwork.* TO 'paperwork'@'localhost'"
  mysql -uroot -e "FLUSH PRIVILEGES"
  php /var/www/paperwork/frontend/artisan migrate --force
  echo "Shutting down."
  mysqladmin -u root shutdown
  sleep 3
  echo "chown time"
  chown -R nobody:users /config/databases
  chmod -R 755 /config/databases
  sleep 3
  echo "Initialization complete."
fi

echo "Starting MariaDB..."
/usr/bin/mysqld_safe --skip-syslog --datadir='/config/databases'
