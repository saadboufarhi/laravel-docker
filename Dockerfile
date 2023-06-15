# Use the official PHP 8.1 image as the base
FROM php:8.1-apache

# Copy the Apache configuration file
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Install additional dependencies
RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
        libonig-dev \
        libzip-dev \
        zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Install PHP extensions and dependencies
RUN docker-php-ext-install pdo pdo_mysql

# Copy the Laravel project files
COPY ./ /var/www/html/./

# Install project dependencies
RUN composer install --no-interaction --optimize-autoloader --no-suggest

# Generate the application key
RUN php artisan key:generate

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Enable Apache rewrite module
RUN a2enmod rewrite
