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
    nginx \
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

# Copiar la configuración de Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Nginx y PHP-FPM
CMD ["sh", "-c", "service nginx start && php-fpm"]