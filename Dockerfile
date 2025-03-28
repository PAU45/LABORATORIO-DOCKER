# Usar la imagen base de PHP-FPM
FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar los archivos de Composer primero
COPY composer.lock composer.json ./

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar el resto de la aplicación
COPY . .

# Instalar dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Exponer el puerto 8000
EXPOSE 8000

# Comando para iniciar el servidor embebido de PHP
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]