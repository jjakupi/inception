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

## Instructions

Before running the project, the machine needs Docker, Docker Compose, Make and Git.

The project is managed with the `Makefile` at the root of the repository.

| Action | Command |
|---|---|
| Build and start the project | `make` |
| Stop the project | `make down` |
| Clean basic Docker resources | `make clean` |
| Full cleanup/reset | `make fclean` |
| Rebuild from scratch | `make re` |

The project domain must point to the local machine or VM.

Add this line to `/etc/hosts` on the machine where the browser is used:

```text
127.0.0.1 jjakupi.42.fr
```

If Docker runs inside a VM, replace `127.0.0.1` with the VM IP address.

Website:

```text
https://jjakupi.42.fr
```

WordPress administration panel:

```text
https://jjakupi.42.fr/wp-admin
```

The TLS certificate is self-signed, so the browser may show a security warning. This is expected for this local project.

For more detailed usage and setup information, see:

| File | Purpose |
|---|---|
| `USER_DOC.md` | User/admin instructions. |
| `DEV_DOC.md` | Developer setup, commands, volumes and persistence. |

---

## Resources

### Official documentation

- Docker documentation https://docs.docker.com/

- **WP-CLI Handbook** — https://developer.wordpress.org/cli/handbook
Used to understand what WP-CLI is and how it can be used to manage WordPress from the command line.

- **WP-CLI Commands Reference** — https://developer.wordpress.org/cli/commands
  Used to check the syntax of commands such as `wp config create`, `wp core install`, and `wp user create`.

- NGINX documentation: https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/



### Additional references

- OpenSSL certificate generation tutorial https://www.youtube.com/watch?v=wzbf9ldvBjM
 	 Helped me understand how to create the `.key` and `.crt` files used by NGINX for TLS.
- Docker networking tutorial: https://www.youtube.com/watch?v=bKFMS5C4CG0&t=15s
- Docker Compose tutorial: `<link>`
### Use of AI

AI was used as a learning and support tool during the project.

It helped with:
- debugging build and runtime errors;
- improving documentation structure and wording.

AI was not used as a replacement for testing or understanding the project. Each part was tested, modified and verified manually.

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

- Virtual machines emulate a complete machine, including virtual hardware such as CPU, memory, storage and network interfaces. Each VM runs its own operating system with its own kernel, which makes VMs strongly isolated but heavier in terms of resources.

- Docker provides lightweight, portable and reproducible environments for running applications. Unlike virtual machines, containers do not run a full operating system with their own kernel. Instead, they share the host system’s kernel and include only the dependencies needed by the application.

---

### Secrets vs Environment Variables

- Environment variables are used to pass configuration values to the containers, such as database names, users and passwords.

- Secrets are better for sensitive data in production, because they are designed to handle confidential values more securely.

In this project, configuration values are provided through the `.env` file. Real passwords should stay local and should not be committed to Git.

---

### Docker Network vs Host Network

- Host network mode is different. When a container uses the host network, it shares the network stack of the Docker host. This means the container does not get its own isolated network interface, and services running inside the container can use the host ports directly.
Host network mode can be useful in some cases, but it reduces isolation and can create security or port conflict issues.
In this project, a Docker bridge network is used instead of host network mode. This keeps WordPress and MariaDB internal, while only NGINX is exposed to the host on port `443`.

- A Docker bridge network is a private virtual network created by Docker. It allows containers connected to the same network to communicate with each other while staying isolated from other networks and from the host, unless ports are explicitly published.

-Inside this network, containers can reach each other by service name, for example `nginx` can reach `wordpress:9000`, and `wordpress` can reach `mariadb:3306`.

---

### Docker Volumes vs Bind Mounts

- A bind mount directly mounts a file or directory from the host machine into a container. The service uses the host path directly, for example `/home/jjakupi/data/mariadb:/var/lib/mysql`. Changes made inside the container are reflected on the host path, and changes made on the host are reflected inside the container.

- Docker volume:
A named volume is a Docker-managed storage object referenced by name. The container mounts the volume using its name, for example `mariadb_data:/var/lib/mysql`, instead of directly using a host path in the service definition. Named volumes are useful for persistent data because they can be managed with Docker commands and reused by containers.

In this project, named volumes are used for MariaDB and WordPress data. They are configured with `driver_opts` so their data is stored under `/home/jjakupi/data`, as required by the subject.

| Volume | Container path | Host path |
|---|---|---|
| `mariadb_data` | `/var/lib/mysql` | `/home/jjakupi/data/mariadb` |
| `wordpress_data` | `/var/www/html` | `/home/jjakupi/data/wordpress` |

This allows the data to remain available after stopping or recreating the containers.
