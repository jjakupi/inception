FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	tar \
	#mariadb-client = tool used to talk to mysqld / MariaDB server
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

#Make PHP-FPM listen on port 9000
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

#WP-CLI:WordPress Command Line Interface,It is a command-line tool to control WordPress.
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/init_wordpress.sh /usr/local/bin/init_wordpress.sh

RUN chmod +x /usr/local/bin/init_wordpress.sh

ENTRYPOINT ["/usr/local/bin/init_wordpress.sh"]
