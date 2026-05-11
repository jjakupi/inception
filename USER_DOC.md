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

## 🌐 Accessing the Website

### Local domain setup

The project uses the domain:

> `jjakupi.42.fr`

Before opening the website, the host machine must know where this domain points.

| Step | Command / Value |
|---|---|
| Open hosts file | `sudo nano /etc/hosts` |
| Add domain entry | `127.0.0.1 jjakupi.42.fr` |

If the project runs inside a virtual machine, replace `127.0.0.1` with the VM IP address.

Example:

```text
192.168.56.10 jjakupi.42.fr
Website URL

🔗 Main website: https://jjakupi.42.fr

The TLS certificate is self-signed, so the browser may show a warning. This is expected for this local project.

🔐 WordPress Administration
Page	URL
Admin panel	https://jjakupi.42.fr/wp-admin

Use the WordPress administrator credentials defined in the environment file.

🔑 Credentials

Credentials are stored in:

srcs/.env

Credential type	Used for
Domain name	Website URL
MariaDB database name	WordPress database
MariaDB username/password	Database connection
WordPress admin credentials	Admin login
WordPress regular user credentials	Second WordPress user

⚠️ Sensitive values should stay local and should not be committed to the repository.

✅ Checking the Services
Running containers
docker ps

Expected containers:

Container	Purpose
nginx	HTTPS entry point
wordpress	Website and PHP-FPM
mariadb	Database
