 User Documentation - Inception

## Project overview

This project runs a WordPress website inside a Docker environment.

It is composed of three services:

- **NGINX**: handles HTTPS connections and acts as the only entry point to the website.
- **WordPress**: provides the website and the administration interface.
- **MariaDB**: stores the WordPress data, such as users, posts, pages and settings.

The services communicate in this order:

```text
Browser -> NGINX -> WordPress -> MariaDB

Only the NGINX service is accessible from outside the Docker network.

Starting and stopping the project

The project is managed with the Makefile located at the root of the repository.

To start the project, run:

make

To stop the project, run:

make down

Stopping the project removes the running containers, but the persistent data remains stored in the volumes.

Accessing the website

Before accessing the website, the domain name must point to the local machine.

Edit the /etc/hosts file:

sudo nano /etc/hosts

Add the following line:

127.0.0.1 jjakupi.42.fr

If the project runs inside a virtual machine, use the VM IP address instead of 127.0.0.1.

The website can then be opened at:

https://jjakupi.42.fr

The TLS certificate is self-signed, so the browser may display a security warning. This is expected for this local setup.

Accessing the WordPress administration panel

The WordPress administration panel is available at:

https://jjakupi.42.fr/wp-admin

Use the WordPress administrator credentials defined in the environment configuration.

Credentials

The project credentials are stored in:

srcs/.env

This file contains the configuration values used by the services, including:

the domain name
the MariaDB database name
the MariaDB username and password
the WordPress administrator credentials
the second WordPress user credentials

Sensitive values should stay local and should not be committed to the repository.

Checking the services

To check if the containers are running, use:

docker ps

The expected containers are:

nginx
wordpress
mariadb
