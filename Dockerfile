FROM php:8.1-fpm

# Instalar dependências
RUN apt-get update && apt-get install -y \
    zip unzip curl git \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd mbstring xml pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar diretório de trabalho
WORKDIR /var/www

# Criar diretórios necessários com permissões adequadas antes de mudar para o usuário www-data
RUN mkdir -p /var/www/storage/logs /var/www/bootstrap/cache && \
    chown -R www-data:www-data /var/www && \
    chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Espera o MySQL iniciar antes de rodar as migrations (Opcional, pode rodar manualmente depois)
CMD ["php-fpm"]
