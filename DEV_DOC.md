# Developer Documentation - Inception

## Project overview

This project builds a small Docker infrastructure with three services:

| Service | Purpose |
|---|---|
| **NGINX** | HTTPS entry point on port `443`. |
| **WordPress** | Website application running with PHP-FPM. |
| **MariaDB** | Database used by WordPress. |

The services communicate like this:

> Browser → NGINX → WordPress → MariaDB

Only **NGINX** is exposed to the host machine.

---

## Prerequisites

Before running the project, the machine needs:

| Tool | Purpose |
|---|---|
| **Docker** | Build images and run containers. |
| **Docker Compose** | Start the multi-container stack. |
| **Make** | Run the project commands. |
| **Git** | Clone and manage the repository. |

To check the tools:

```bash
docker --version
docker compose version
make --version
git --version
```

---

## Setup from scratch

Clone the repository:

```bash
git clone <repository_url>
cd Inception
```

Before starting the project, make sure the persistent data path matches the user running the project.

For this repository, the expected path is: `/home/jjakupi/data`


If the project is tested with another login, replace `jjakupi` with the correct login in the `Makefile` and in `srcs/docker-compose.yml`.

The required folders are normally created by the `Makefile` when running: `make` make sure to change  with the correct `login` instead of `jjakupi`.

If they need to be created manually, use:

```bash
sudo mkdir -p /home/jjakupi/data/mariadb
sudo mkdir -p /home/jjakupi/data/wordpress
sudo chown -R $USER:$USER /home/jjakupi/data
```

Add the project domain to `/etc/hosts` on the machine where the browser is used: `127.0.0.1 jjakupi.42.fr`

If the project runs inside a virtual machine, use the VM IP address instead of `127.0.0.1`.

---

## Configuration and secrets

The project needs an environment file at: `srcs/.env`

This file is not committed to Git because it can contain passwords.

To create it, make a new file: `srcs/.env`

Then add the required variables:

```env
DOMAIN_NAME=https://jjakupi.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=<database_password>
MYSQL_ROOT_PASSWORD=<root_database_password>

WORDPRESS_TITLE=Inception
WORDPRESS_ADMIN_USER=<admin_username>
WORDPRESS_ADMIN_PASSWORD=<admin_password>
WORDPRESS_ADMIN_EMAIL=<admin_email>

WORDPRESS_USER=<regular_username>
WORDPRESS_USER_PASSWORD=<regular_user_password>
WORDPRESS_USER_EMAIL=<regular_user_email>
```

Replace the values between `< >` with local values before running the project.

The WordPress administrator username should not contain `admin` or `administrator`.


---

## Project structure

The main structure is:

```text
Inception/
├── Makefile
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        ├── wordpress/
        └── mariadb/
```

The most important files are:

| File / Folder | Purpose |
|---|---|
| `Makefile` | Provides simple commands to build, start and clean the project. |
| `srcs/docker-compose.yml` | Defines services, network, volumes and port mapping. |
| `srcs/.env` | Stores environment variables and credentials. |
| `srcs/requirements/nginx/` | NGINX image, TLS setup and NGINX configuration. |
| `srcs/requirements/wordpress/` | WordPress/PHP-FPM image and WordPress setup. |
| `srcs/requirements/mariadb/` | MariaDB image, configuration and database setup. |

---

## Build and launch

From the root of the repository:

```bash
make
```

This builds the images and starts the containers using Docker Compose.

To stop the project:

```bash
make down
```

This stops and removes the containers, but keeps persistent data.

| Command | Purpose |
|---|---|
| `make` | Build and start the project. |
| `make down` | Stop and remove containers. |
| `make clean` | Clean basic Docker resources, depending on the Makefile. |
| `make fclean` | Full cleanup/reset, depending on the Makefile. |

---

## Docker Compose

Docker Compose is configured in:

> `srcs/docker-compose.yml`

It defines:

- the three services: `nginx`, `wordpress`, `mariadb`
- the Docker network
- the named volumes
- the `.env` file
- the NGINX port mapping

Only NGINX exposes a port to the host:

```text
443:443
```

WordPress and MariaDB stay inside the Docker network.

---

## Useful commands

| Command | Purpose |
|---|---|
| `docker ps` | Show running containers. |
| `docker images` | Show built images. |
| `docker volume ls` | Show Docker volumes. |
| `docker network ls` | Show Docker networks. |

Check logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Enter a container:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

---

## Data storage and persistence

The project uses Docker named volumes for persistent data.

| Data | Container path | Host path |
|---|---|---|
| MariaDB data | `/var/lib/mysql` | `/home/jjakupi/data/mariadb` |
| WordPress files | `/var/www/html` | `/home/jjakupi/data/wordpress` |

MariaDB stores database data such as users, posts, pages and WordPress settings.

WordPress stores website files such as themes, plugins, uploads and `wp-config.php`.

Because this data is stored in volumes, it remains available after:

```bash
make down
```

To check the stored data on the host:

```bash
ls /home/jjakupi/data/mariadb
ls /home/jjakupi/data/wordpress
```

---

## Basic validation checks

After starting the project, check the containers:

```bash
docker ps
```

Expected containers:

| Container | Role |
|---|---|
| `nginx` | HTTPS entry point |
| `wordpress` | Website and PHP-FPM |
| `mariadb` | Database |

If the containers are running, the website answers, and the data exists in `/home/jjakupi/data`, the project is correctly built and persistent.
