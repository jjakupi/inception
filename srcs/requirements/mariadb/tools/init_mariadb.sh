#!/bin/bash

# Start MariaDB message
echo "Starting MariaDB..."

# Create required folder for socket
mkdir -p /run/mysqld

# Give permission to mysql user
chown -R mysql:mysql /run/mysqld

# Start MariaDB in background
mysqld_safe &

# Wait for MariaDB to be ready
sleep 5

# Create database
echo "Creating database and user..."

 #-u = user -e execute
mysql -u root -e "CREATE DATABASE $MYSQL_DATABASE;"

mysql -u root -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

mysql -u root -e "FLUSH PRIVILEGES;"

echo "Setup done!"


# Stop MariaDB
mysqladmin -u root shutdown

# Start MariaDB normally
mysqld
