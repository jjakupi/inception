#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f "index.php" ]; then
	echo "Downloading WordPress..."

	curl -O https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz
	mv wordpress/* .
	rm -rf wordpress latest.tar.gz
fi

mkdir -p /run/php
chown -R www-data:www-data /run/php

exec php-fpm7.4 -F
