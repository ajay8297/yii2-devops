FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer 2.7.7
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.7.7

# Install php-fpm-healthcheck
RUN curl -sS https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    -o /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Explicitly allow Composer plugins
RUN composer config --no-plugins allow-plugins.yiisoft/yii2-composer true
RUN composer config --no-plugins allow-plugins.foxy/foxy true

# Install Yii2 dependencies
RUN composer install --no-interaction --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /app

# Expose port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
