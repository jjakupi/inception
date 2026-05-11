# User Documentation - Inception

## Project overview

This project runs a WordPress website inside a Docker environment.

| Service | Purpose |
|---|---|
| **NGINX** | Handles HTTPS connections and acts as the only public entry point. |
| **WordPress** | Provides the website and the administration interface. |
| **MariaDB** | Stores WordPress data such as users, posts, pages and settings. |

The services communicate like this:

> Browser → NGINX → WordPress → MariaDB

Only **NGINX** is accessible from outside the Docker network.

---

## Starting and stopping the project

The project is managed with the `Makefile` located at the root of the repository.

| Action | Command |
|---|---|
| Start the project | `make` |
| Stop the project | `make down` |

Stopping the project removes the running containers, but the persistent data remains stored in the volumes.

---

## Accessing the website

Before accessing the website, the domain name must point to the local machine.

Edit the `/etc/hosts` file on the host machine:

sudo nano /etc/hosts

Add the following line:

127.0.0.1 jjakupi.42.fr

If the project runs inside a virtual machine, use the VM IP address instead of 127.0.0.1.

The website is available at:

https://jjakupi.42.fr

The TLS certificate is self-signed, so the browser may display a security warning. This is expected for this local setup.

Accessing the WordPress administration panel

The WordPress administration panel is available at:

https://jjakupi.42.fr/wp-admin

Use the WordPress administrator credentials defined in the environment configuration.

Credentials

Project credentials are stored in:

srcs/.env

This file contains values such as:

the domain name
the MariaDB database name
the MariaDB username and password
the WordPress administrator credentials
the second WordPress user credentials

Sensitive values should stay local and should not be committed to the repository.

Checking the services

To check if the containers are running:

docker ps

Expected containers:

Container
nginx
wordpress
mariadb
