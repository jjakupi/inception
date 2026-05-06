#!/bin/bash

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/jjakupi.42.fr.key \
	-out /etc/nginx/ssl/jjakupi.42.fr.crt \
	-subj "/C=CH/ST=Vaud/L=Lausanne/O=42/OU=Inception/CN=jjakupi.42.fr"

exec nginx -g "daemon off;"
