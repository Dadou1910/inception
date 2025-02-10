#!/bin/bash

# Loops until MariaDB is ready
until mysql -h "mariadb" -u"$DATA_USER" -p"$DATA_PASS" -e "SELECT 1;" &> /dev/null; do
    echo "waiting for MariaDB..."
    sleep 2
done

echo "MariaDB is ready, installation of Wordpress..."

# Switches to the directory where WordPress is installed
cd /var/www/html

# If not already, download wp-cli (WordPress CLI tool) & make it executable
if [ ! -f "wp-cli.phar" ]; then
    echo "downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# If not already, creates wp-config.php with database details
# (WordPress config)
if [ ! -f "wp-config.php" ]; then
    echo "Configuration of WordPress..."
    ./wp-cli.phar config create \
        --dbname="$DATA_NAME" \
        --dbuser="$DATA_USER" \
        --dbpass="$DATA_PASS" \
        --dbhost="mariadb:3306" \
        --allow-root
else
    echo "wp-config.php already exists"
fi

# If not alread, download WordPress (handles installation and
# existing WordPress setups)
if ! ./wp-cli.phar core is-installed --allow-root; then
    echo "Installation of WordPress..."
    ./wp-cli.phar core install \
        --url="$DOMAIN_NAME" \
        --title="$WEBSITE_HEADER" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --allow-root
else
    echo "WordPress is already installed."
fi

# Creates the user if it doesn't already exists
if ! ./wp-cli.phar user list --allow-root | grep -q "$WP_USER"; then
    echo "Création of user1 WordPress..."
    ./wp-cli.phar user create "$WP_USER" "$WP_EMAIL" --role="$WP_ROLE" --user_pass="$WP_PASSWORD" --allow-root
else
    echo "$WP_USER already exists."
fi

# Starts PHP-FPM in foreground (keeps php running in container)
php-fpm8.2 -F