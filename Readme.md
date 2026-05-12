*This project has been created as part of the 42 curriculum by jjakupi.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum.

The goal of this project is to build a small web infrastructure using Docker. Each service runs in its own container and is configured manually with custom Dockerfiles.

The infrastructure runs a WordPress website with NGINX as the secure HTTPS entry point and MariaDB as the database.

The stack is composed of:

| Service | Role |
|---|---|
| **NGINX** | Handles HTTPS connections and acts as the only public entry point. |
| **WordPress** | Runs the website using PHP-FPM. |
| **MariaDB** | Stores the WordPress database. |

The services communicate through a dedicated Docker network, and persistent data is stored with Docker volumes.

> Browser → NGINX → WordPress/PHP-FPM → MariaDB

---

## Project description

This project uses Docker to build a small web infrastructure composed of three separate services: NGINX, WordPress and MariaDB.

Docker is used to isolate each service in its own container. Instead of installing everything directly on the host machine, each service is built from its own Dockerfile and runs with only the tools it needs.

The project sources are stored inside the `srcs/` directory:

| Path | Purpose |
|---|---|
| `srcs/docker-compose.yml` | Defines the services, network, volumes and port mapping. |
| `srcs/.env` | Stores environment variables used by the containers. |
| `srcs/requirements/nginx/` | Contains the NGINX Dockerfile, configuration and startup script. |
| `srcs/requirements/wordpress/` | Contains the WordPress/PHP-FPM Dockerfile and setup script. |
| `srcs/requirements/mariadb/` | Contains the MariaDB Dockerfile, configuration and initialization script. |

The main design choice is to keep one service per container:

> NGINX → WordPress/PHP-FPM → MariaDB

NGINX is the only service exposed to the host machine, through HTTPS on port `443`. WordPress and MariaDB are not directly accessible from outside the Docker network.

The services communicate through a dedicated Docker network, using their service names. For example, NGINX forwards PHP requests to `wordpress:9000`, and WordPress connects to the database using the hostname `mariadb`.

Persistent data is stored with Docker named volumes. MariaDB data is stored in `/home/jjakupi/data/mariadb`, and WordPress files are stored in `/home/jjakupi/data/wordpress`. This keeps the website data available even if the containers are stopped or recreated.

---

## Main design choices

### Virtual Machines vs Docker

A virtual machine runs a complete operating system with its own kernel. It is powerful, but heavier because each VM needs its own full system.

Docker containers share the host kernel and isolate only the application environment. They are lighter, faster to start and easier to rebuild.

For this project, Docker is used because each service can run in a separate and reproducible environment without needing a full virtual machine for each service.

---

### Secrets vs Environment Variables

Environment variables are used to pass configuration values to the containers, such as database names, users and passwords.

Secrets are better for sensitive data in production, because they are designed to handle confidential values more securely.

In this project, configuration values are provided through the `.env` file. Real passwords should stay local and should not be committed to Git.

---

### Docker Network vs Host Network

A Docker network allows containers to communicate with each other using service names.

For example:

> NGINX → `wordpress:9000`
> WordPress → `mariadb:3306`

This keeps internal services isolated from the host machine.

Using the host network would make containers share the host network directly, which removes part of the isolation.

For this project, a dedicated Docker network is used. Only NGINX is exposed to the host, while WordPress and MariaDB remain internal.

---

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are commonly used to persist container data.

Bind mounts directly link a specific host path to a container path.

This project uses Docker named volumes for persistent storage, with host paths configured for the required data directories:

| Data | Container path | Host path |
|---|---|---|
| MariaDB data | `/var/lib/mysql` | `/home/jjakupi/data/mariadb` |
| WordPress files | `/var/www/html` | `/home/jjakupi/data/wordpress` |

This allows the data to remain available even after containers are stopped or recreated.

---

## Instructions

### Prerequisites

Before running the project, the machine needs:

- Docker
- Docker Compose
- Make
- Git

The project domain must point to the local machine or VM.

Add this line to `/etc/hosts` on the machine where the browser is used:

```text
127.0.0.1 jjakupi.42.fr
```

If Docker runs inside a VM, replace `127.0.0.1` with the VM IP address.

---

### Build and start

From the root of the repository, run:

```bash
make
```

This builds the Docker images and starts the containers.

---

### Stop the project

```bash
make down
```

This stops and removes the containers while keeping persistent data.

---

### Clean

```bash
make clean
```

This cleans basic Docker resources, depending on the Makefile rules.

---

### Full reset

```bash
make fclean
```

Use this carefully, because it may remove images, volumes and persistent data.

---

### Rebuild

```bash
make re
```

This performs a full cleanup and starts the project again.

---

## Access

Website:

```text
https://jjakupi.42.fr
```

WordPress administration panel:

```text
https://jjakupi.42.fr/wp-admin
```

The TLS certificate is self-signed, so the browser may show a security warning. This is expected for this local project.

---

## Useful commands

Check running containers:

```bash
docker ps
```

Check logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Check NGINX configuration:

```bash
docker exec -it nginx nginx -t
```

Check WordPress users:

```bash
docker exec -it wordpress bash
cd /var/www/html
wp user list --allow-root
```

Check volumes:

```bash
docker volume ls
```

---

## Documentation

More detailed documentation is available in:

| File | Purpose |
|---|---|
| `USER_DOC.md` | Explains how to use the project as a user or administrator. |
| `DEV_DOC.md` | Explains how to set up, build, debug and understand the project as a developer. |

---

## Resources

### Official documentation

- Docker documentation: `<link>`
- Docker Compose documentation: `<link>`
- Dockerfile reference: `<link>`
- NGINX documentation: `<link>`
- NGINX HTTPS / SSL configuration: `<link>`
- MariaDB documentation: `<link>`
- WordPress documentation: `<link>`
- WP-CLI documentation: `<link>`
- OpenSSL documentation: `<link>`

### Additional references

- Docker basics article or tutorial: `<link>`
- Docker Compose tutorial: `<link>`
- NGINX and PHP-FPM tutorial: `<link>`
- TLS certificates tutorial: `<link>`

### Use of AI

AI was used as a learning and support tool during the project.

It helped with:

- understanding Docker concepts such as images, containers, volumes and networks;
- understanding Dockerfile instructions such as `FROM`, `RUN`, `COPY`, `CMD` and `ENTRYPOINT`;
- explaining how MariaDB, WordPress, PHP-FPM and NGINX communicate together;
- debugging build and runtime errors;
- understanding TLS, HTTPS, OpenSSL certificates and private keys;
- improving documentation structure and wording.

AI was not used as a replacement for testing or understanding the project. Each part was tested, modified and verified manually.





https://developer.wordpress.org/cli/commands/ ---- used for the command of wordpress
https://depot.dev/blog/docker-build-image explained
