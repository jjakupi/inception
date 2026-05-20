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


Before running the project, the machine needs Docker, Docker Compose, Make and Git.


<details>
<summary>Click here to see installation instructions</summary>

### Install Git and Make

```bash
sudo apt update
sudo apt install -y git make
```

Check installation:

```bash
git --version
make --version
```

### Install Docker and Docker Compose

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
```

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Check installation:

```bash
docker --version
docker compose version
```

Test Docker:

```bash
sudo docker run hello-world
```

### Run Docker without sudo

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Then log out and log back in, or run:

```bash
newgrp docker
```

Test again:

```bash
docker run hello-world
```

</details>


---

## Setup from scratch

Clone the repository:

```bash
git clone <repository_url>
cd Inception
```

Before starting the project, make sure the persistent data path matches the user running the project.

For this repository, the expected path is: `/home/jjakupi/data`


If the project is used with another login, replace jjakupi with the correct login in:

- Makefile - already creats the folders so make sure to change the `<login>`
- srcs/docker-compose.yml
- domain configuration, if needed


Add the project domain to `/etc/hosts` on the machine where the browser is used: `127.0.0.1 jjakupi.42.fr`

If the project runs inside a virtual machine, use the VM IP address instead of `127.0.0.1`.

---

## Configuration and secrets

The project needs an environment file at: `srcs/.env`

This file is not committed to Git because it can contain passwords.

But it will be created the moment you `make` and copy the required variables from `srcs/.env.example` to `srcs/.env`.

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


| Action | Command |
|---|---|
| Build and start the project | `make` |
| Stop the project | `make down` |
| Clean basic Docker resources | `make clean` |
| Full cleanup/reset | `make fclean` |
| Rebuild from scratch | `make re` |

---

## Docker Compose commands

The project containers are managed with Docker Compose using the file:

```bash
srcs/docker-compose.yml
```

### Build and start the containers

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

- `up` creates and starts the containers.
- `--build` builds the images before starting them.
- `-d` runs the containers in the background.

---

### Stop the containers

```bash
docker compose -f srcs/docker-compose.yml down
```

Stops and removes the containers and the Docker network.

This does not remove persistent volumes.

---

### Check container status

```bash
docker compose -f srcs/docker-compose.yml ps
```

Shows the status of the project containers.

---

### View logs

```bash
docker compose -f srcs/docker-compose.yml logs
```

Shows logs from all services.


To see logs for one service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

---

### Restart containers

```bash
docker compose -f srcs/docker-compose.yml restart
```

Restarts all containers without rebuilding them.

To restart one service:

```bash
docker compose -f srcs/docker-compose.yml restart nginx
```

---

### Enter a container

```bash
docker compose -f srcs/docker-compose.yml exec nginx bash
```

Opens a shell inside a running container.

Examples:

```bash
docker compose -f srcs/docker-compose.yml exec wordpress bash
docker compose -f srcs/docker-compose.yml exec mariadb bash
```
---

### Stops and removes the containers

```bash
docker compose -f srcs/docker-compose.yml down
```

This does not remove volumes, so persistent data is kept.

---

### Remove containers and volumes

```bash
docker compose -f srcs/docker-compose.yml down -v
```

Stops the containers and removes the Docker volumes.

Warning: this can delete persistent project data, such as the database and WordPress files.

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
