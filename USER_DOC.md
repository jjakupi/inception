# User Documentation - Inception

## Services Provided

This infrastructure provides a complete web hosting stack:

- **NGINX:** a web server acting as the secure entry point of the website through HTTPS.
- **WordPress:** the content management system used to manage the website.
- **MariaDB:** the database engine that stores the WordPress data.

The request flow is:

Browser -> NGINX -> WordPress -> MariaDB

Only NGINX is accessible from outside the Docker network.

How to start and stop the project

The project is handled with a Makefile located at the root of the repository.

To start the project, open your terminal and run:
make
To stop the project, run:
make down

Stopping the project removes the containers, but the persistent data remains stored in the volumes.

Accessing the website and admin panel
Prerequisites

Before accessing the website, the local machine must recognize the domain name.

Add the following line to /etc/hosts:

127.0.0.1 jjakupi.42.fr

If the project is running inside a virtual machine, replace 127.0.0.1 with the IP address of the VM.

URLs
Main website: https://jjakupi.42.fr
WordPress admin panel: https://jjakupi.42.fr/wp-admin

The TLS certificate is self-signed, so the browser may show a security warning. This is normal for this project.

Managing credentials

All credentials and configuration values are stored in:

srcs/.env

This file contains values such as:

the domain name
the MariaDB database name
the MariaDB username and password
the WordPress administrator username and password
the second WordPress user credentials

For security reasons, real passwords should not be hardcoded inside Dockerfiles or committed to Git.

Checking service status

To verify that all services are running correctly, use:

docker ps

The expected containers are:

nginx
wordpress
mariadb

To check service logs:

docker logs nginx
docker logs wordpress
docker logs mariadb

To test the website from the terminal:

curl -k https://jjakupi.42.fr

The -k option is used because the certificate is self-signed.

Persistent data

The project stores persistent data on the host machine under:

/home/jjakupi/data

MariaDB data is stored in:

/home/jjakupi/data/mariadb

WordPress files are stored in:

/home/jjakupi/data/wordpress

This allows the website data to remain available even after stopping the project with:

make down
