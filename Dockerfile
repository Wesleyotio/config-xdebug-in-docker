FROM php:8.1.0-fpm

# Copy composer.lock and composer.json
RUN if [-f composer.lock] && [-f composer.json] ; then \
    COPY composer.lock composer.json /var/www/ ; \ 
    fi

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libzip-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN pecl install xdebug && docker-php-ext-enable xdebug 
RUN docker-php-ext-install pdo_mysql zip exif pcntl
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Installing node 12.x
RUN curl -sL https://deb.nodesource.com/setup_12.x| bash -
RUN apt-get install -y nodejs

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www



# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
# COPY é uma instrução que copia arquivos e diretorios para o sistema de arquivos do container.

# ADD é como uma instrução de copia com mais recursos. Além de copiar arquivos dos host para a imagem de container, a instrução ADD também copia arquivos de um local remoto com uma especificação de URL
# CMD define um comando padrao a ser executado duante a impalntação de uma instância da imagem do container
#EX: Se o container estiver hospedado em um servidor WEB NGINX o CMD pode incluir instruções para iniciar o servidor com um comando.
#OBS: Se varias instruções CMD forem especcificadas em um Dockerfile, somente a ultima será avalidada.
