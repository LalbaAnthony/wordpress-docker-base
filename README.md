# Deault WordPress Docker Environment

A default WordPress environment using Docker, designed to be used as a base for WordPress development projects. This setup includes a MariaDB database and is configured to work with the latest version of WordPress.

## 🚀 - Quick start

1. Clone the rep
   ```bash
   git clone <URL>
   ```

2. Copy the `.env.example` file to `.env` and fill in the required environment variables.
    ```bash
    cp .env.example .env
    ```

3. Ensure all bash files are saved with Unix line endings (`LF`) and not Windows line endings (`CRLF`).

### 🐋 - With Docker

```bash
docker compose down -v
docker-compose up --build
```

#### Debug

```bash
# Check that wp-config.php is correctly configured
docker exec -it tl_backend_wp sh
grep -E "DB_(HOST|NAME|USER|PASSWORD)" /var/www/html/wp-config.php

# Check that database is correctly configured
docker exec -it tl_database_mariadb sh
mariadb -u root -p # ? Connect using MARIADB_ROOT_PASSWORD
```