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
The project needs an environment file at: `srcs/.env`

This file is not committed to Git because it can contain passwords.

But it will be created the moment you `make` and copy the required variables from `srcs/.env.example` to `srcs/.env`.

Replace the values between `< >` with local values before running the project.

The WordPress administrator username should not contain `admin` or `administrator`.

```bash
make down
make
```

Sensitive values should stay local and should not be committed to Git.

---

## Checking the services

| Command | Purpose |
|---|---|
| `docker ps` | Show running containers. |
| `docker images` | Show built images. |
| `docker volume ls` | Show Docker volumes. |
| `docker network ls` | Show Docker networks. |
