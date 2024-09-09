FROM php:7.4-fpm

# Install extensions untuk PHP
RUN docker-php-ext-install mysqli

# Salin file aplikasi ke direktori kerja
COPY ./index.php /var/www/html/index.php

# Nginx
FROM nginx:alpine

# Salin konfigurasi Nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Jalankan Nginx
CMD ["nginx", "-g", "daemon off;"]