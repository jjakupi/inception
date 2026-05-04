FROM debian:bullseye

#WordPress is written in PHP.
#PHP-FPM = program that executes PHP code
#php-mysql      = for WORDPRESS PHP code to talk to MariaDB
#mariadb-client = for me / scripts to test MariaDB with mysql command
#mariadb-client = tool used to talk to mysqld / MariaDB server
RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	tar \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

	#before PHP-FPM listens on a socket file.
	#A socket file is only easy inside the same container.
	#Port 9000 works through the Docker network.
	#then make PHP-FPM listen on port 9000
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

#WP-CLI:WordPress Command Line Interface,It is a command-line tool to control WordPress.
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

	#This takes your script from your project folder and puts it inside the image.
COPY ./tools/init_wordpress.sh /usr/local/bin/init_wordpress.sh

#Make the script executable
RUN chmod +x /usr/local/bin/init_wordpress.sh

#When the container starts, run this script.
ENTRYPOINT ["/usr/local/bin/init_wordpress.sh"]
