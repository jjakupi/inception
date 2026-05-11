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
---

## Website access

Before opening the website, add the domain to `/etc/hosts` on the host machine:

```text
127.0.0.1 jjakupi.42.fr
```

Then open one of these URLs:

| Page | URL |
|---|---|
| Website | `https://jjakupi.42.fr` |
| WordPress admin | `https://jjakupi.42.fr/wp-admin` |

The certificate is self-signed, so the browser may show a warning. This is normal for this project.

---

## Credentials

Credentials are stored in:

```text
srcs/.env
```

This file contains:

| Value | Description |
|---|---|
| `DOMAIN_NAME` | Website domain |
| `MYSQL_DATABASE` | MariaDB database name |
| `MYSQL_USER` / `MYSQL_PASSWORD` | MariaDB user credentials |
| `WORDPRESS_ADMIN_USER` / `WORDPRESS_ADMIN_PASSWORD` | WordPress administrator credentials |
| `WORDPRESS_USER` / `WORDPRESS_USER_PASSWORD` | Second WordPress user credentials |

To change credentials, edit `srcs/.env`, then restart the project:

```bash
make down
make
```

Sensitive values should stay local and should not be committed to Git.

---

## Checking the services

To check that the project is running:

```bash
docker ps
```

You should see these containers:

| Container | Service |
|---|---|
| `nginx` | HTTPS entry point |
| `wordpress` | WordPress and PHP-FPM |
| `mariadb` | Database |

If all three containers are running, the stack is started correctly.
