#!/bin/bash

# Create the website folder and move into it.
mkdir -p /var/www/html
cd /var/www/html

# Wait until the MariaDB container accepts connections.
# SELECT 1 is only a test query; it does not modify the database.
until mysql -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1"; do
	echo "Waiting for MariaDB..."
	sleep 2
done

# Extra wait because MariaDB may restart after its initialization phase.
sleep 10

# If WordPress files are not present yet, download and extract them.
# index.php is one of the main WordPress files.
if [ ! -f "index.php" ]; then
	echo "Downloading WordPress..."

	# -O saves the file with its original remote name: latest.tar.gz
	curl -O https://wordpress.org/latest.tar.gz

	# Extract the WordPress archive.
	tar -xzf latest.tar.gz

	# Move files from /var/www/html/wordpress into /var/www/html.
	mv wordpress/* .

	# Remove useless archive and temporary folder.
	rm -rf wordpress latest.tar.gz
fi

# If wp-config.php does not exist, create it.
# wp-config.php tells WordPress how to connect to MariaDB.
if [ ! -f "wp-config.php" ]; then
	echo "Creating WordPress config..."

	# dbhost is "mariadb" because MariaDB is in another container.
	# It is not localhost.
	wp config create \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb \
		--allow-root
fi

# Wait again to make sure MariaDB is available before installing WordPress.
until mysql -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1"; do
	echo "Waiting for MariaDB final start..."
	sleep 2
done

# If WordPress is not installed yet, install it and create users.
if ! wp core is-installed --allow-root; then
	echo "Installing WordPress..."

	# Install WordPress and create the administrator user.
	wp core install \
		--url=$DOMAIN_NAME \
		--title=$WORDPRESS_TITLE \
		--admin_user=$WORDPRESS_ADMIN_USER \
		--admin_password=$WORDPRESS_ADMIN_PASSWORD \
		--admin_email=$WORDPRESS_ADMIN_EMAIL \
		--allow-root

	echo "Creating second WordPress user..."

	# Create the second non-admin WordPress user.
	wp user create \
		$WORDPRESS_USER \
		$WORDPRESS_USER_EMAIL \
		--user_pass=$WORDPRESS_USER_PASSWORD \
		--role=author \
		--allow-root
fi

mkdir -p /run/php #Creates runtime folder for PHP-FPM.
#change owner recursive, apply to folder and everything inside
chown -R www-data:www-data /run/php
#The first www-data is the user.The second www-data is the group.
#www-data = user that needs to use /run/phpm
#On Debian, web services like NGINX/PHP-FPM often use the user:www-data
#So this gives PHP-FPM permission to use /run/php.
exec php-fpm7.4 -F #exec php-fpm7.4 -F This starts PHP-FPM
#exec means:replace the script process with php-fpm,So PHP-FPM becomes the main process of the container.
