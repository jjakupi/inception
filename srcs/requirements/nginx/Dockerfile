FROM debian:bullseye

RUN apt -y update && apt install -y nginx && apt install openssl -y \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/init_nginx.sh /usr/local/bin/init_nginx.sh

COPY ./conf/nginx.conf /etc/nginx/sites-available/default

RUN chmod +x /usr/local/bin/init_nginx.sh

CMD ["/usr/local/bin/init_nginx.sh"]
