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

Create the required data folders on the host machine:

```bash
mkdir -p /home/jjakupi/data/mariadb
mkdir -p /home/jjakupi/data/wordpress
```

Add the project domain to `/etc/hosts` on the machine where the browser is used:

```text
127.0.0.1 jjakupi.42.fr
```

If the project runs inside a virtual machine, use the VM IP address instead of `127.0.0.1`.

---

## Configuration and secrets

The project uses an environment file:

> `srcs/.env`

This file contains the values used by the services:

| Value | Used for |
|---|---|
| Domain name | Website URL |
| MariaDB database name | WordPress database |
| MariaDB username/password | Database connection |
| WordPress administrator credentials | Admin account |
| WordPress regular user credentials | Second WordPress user |

The real `.env` file should stay local and should not be committed to Git.

A common setup is to provide an example file:

> `srcs/.env.example`

Then create the real environment file locally:

```bash
cp srcs/.env.example srcs/.env
nano srcs/.env
```

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
