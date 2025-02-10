#!/bin/bash

# DEFINITIONS
# MysSQL : relational database management system used to store, manage,
# and retrieve data (sotrinf user info, handling transactions,
# running WordPress, ...)

if pgrep mysqld > /dev/null; then
    echo "MariaDB is already running"
    killall -9 mysqld mysqld_safe
fi

# Makes sapces to regenerate clean logs
rm -f /var/lib/mysql/aria_log_control /var/lib/mysql/aria_log.*

# Prepares the mysql runtime directory
# -p ensures it does not fail in case the directory is already there
mkdir -p /run/mysqld
# -R is for recursive : applies for all files in directory
chown -R mysql:mysql /run/mysqld

# Check if MariaDB is initialized (if var/lib...etc exists),
# initializes if not
# --user=mysql for correct user
# --ldata..etc... for data directory
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation of database"
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# Starts MariaDB server and allows external connections
echo "MariaDB is starting"
mysqld --bind-address=0.0.0.0 &
sleep 5

# Checks if MariaDB is responsive, restarts the command until it is
# (after a 2 sec sleep time)
until mysql -h "localhost" -u root -e "SELECT 1;" &> /dev/null; do
    echo "MariaDB is not responding"
    sleep 2
done

echo "MariaDB is ready"

# CONNECTS MARIADB AS ROOT
# Sets the root password
# Creates a new database if it doesn't exist
# Create a new user if doesn't exist
# All permissions given to new user
# Apply changes
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DATA_PASS}';
CREATE DATABASE IF NOT EXISTS \`${DATA_NAME}\`;
CREATE USER IF NOT EXISTS '${DATA_USER}'@'%' IDENTIFIED BY '${DATA_PASS}';
GRANT ALL PRIVILEGES ON \`${DATA_NAME}\`.* TO '${DATA_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Prints a list of MariaDB users (check creation)
mysql -u root -p"${DATA_PASS}" -e "SELECT User, Host FROM mysql.user;"

# Waits 2 sec and cleanly shuts down MariaDB
sleep 2
mysqladmin -u root -p"${DATA_PASS}" shutdown

# Starts MariaDB in the foreground (keeps container alive)
# Replaces the cripts by mysql and becomes the main process in container
exec mysqld