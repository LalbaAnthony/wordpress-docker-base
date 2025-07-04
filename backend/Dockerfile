FROM wordpress:php8.1-apache

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Install MySQL client for health checks
RUN apt-get update \
    && apt-get install -y default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

COPY wordpress/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh \
    && chown -R www-data:www-data /var/www/html

# Pre-populate plugins & themes
COPY wordpress/plugins/ /var/www/html/wp-content/plugins/
COPY wordpress/themes/  /var/www/html/wp-content/themes/

# Suppress Apache warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENTRYPOINT ["bash", "/usr/local/bin/init.sh"]
CMD ["apache2-foreground"]
