# Usar la imagen base de PHP
FROM php:8.2-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Establecer el directorio de trabajo
WORKDIR /var/www

# Copiar los archivos de la aplicación
COPY . .

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Establecer permisos
RUN chown -R www-data:www-data storage bootstrap/cache

# Exponer el puerto 8000
EXPOSE 8000

# Comando para iniciar el servidor
CMD ["php-fpm"]