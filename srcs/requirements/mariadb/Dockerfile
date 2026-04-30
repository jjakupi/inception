FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/init_mariadb.sh /usr/local/bin/

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /usr/local/bin/init_mariadb.sh

ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
