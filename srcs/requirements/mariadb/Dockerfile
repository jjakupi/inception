FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/init_mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_mariadb.sh

ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
