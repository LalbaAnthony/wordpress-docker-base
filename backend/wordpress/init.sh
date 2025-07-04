#!/usr/bin/env bash

set -euo pipefail

APACHE_DOC_PATH=/var/www/html
WP_CLI_PATH=/usr/local/bin/wp
PHP_ARGS="-d memory_limit=256M"

# Required env vars:
: "${WP_DB_HOST:?Need to set WP_DB_HOST}"
: "${WP_DB_NAME:?Need to set WP_DB_NAME}"
: "${WP_DB_USER:?Need to set WP_DB_USER}"
: "${WP_DB_PASSWORD:?Need to set WP_DB_PASSWORD}"
: "${WP_URL:?Need to set WP_URL}"
: "${WP_TITLE:?Need to set WP_TITLE}"
: "${WP_ADMIN_USER:?Need to set WP_ADMIN_USER}"
: "${WP_ADMIN_PASSWORD:?Need to set WP_ADMIN_PASSWORD}"
: "${WP_ADMIN_EMAIL:?Need to set WP_ADMIN_EMAIL}"

cd "$APACHE_DOC_PATH"

# Download core if missing
if [ ! -f index.php ]; then
  echo "📦 Downloading WordPress core..."
  php $PHP_ARGS $WP_CLI_PATH core download --allow-root
else
  echo "✅ WordPress core already downloaded."
fi

# Generate config if missing
if [ ! -f wp-config.php ]; then
  echo "⚙️ Generating wp-config.php..."
  php $PHP_ARGS $WP_CLI_PATH config create \
    --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASSWORD" \
    --dbhost="$WP_DB_HOST" \
    --skip-check \
    --allow-root
else
  echo "✅ wp-config.php already exists."
fi

# Install core if not already installed
if [ ! php $PHP_ARGS $WP_CLI_PATH core is-installed --allow-root >/dev/null 2>&1 ]; then
  echo "🚀 Installing WordPress..."
  php $PHP_ARGS $WP_CLI_PATH core install \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
else
  echo "✅ WordPress is already installed."
fi

# Activate any bundled plugins
echo "🔌 Activating plugins..."
for plugin_dir in wp-content/plugins/*/; do
  slug=$(basename "$plugin_dir")
  php $PHP_ARGS $WP_CLI_PATH plugin activate "$slug" --allow-root || true
done
echo "✅ Plugins activated."

# Apply pretty permalinks
php $PHP_ARGS $WP_CLI_PATH rewrite structure '/%postname%/' --allow-root

echo "🎉 Bootstrap complete, handing off to Apache..."
exec apache2-foreground

echo "✅ WordPress is ready at $WP_URL"