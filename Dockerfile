FROM ubuntu:20.04

RUN \
# Update and get dependencies
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
    nginx \
    php8.1 php8.1-fpm php8.1-cli

RUN \
# Setup PHP
    echo \
         " server { \n" \
         "   listen 8080; \n" \
         "   root /var/www; \n" \
         "   location ~ php/.* { \n" \
         "     include snippets/fastcgi-php.conf; \n" \
         "     fastcgi_param HTTP_PROXY ""; \n" \
         "     fastcgi_pass unix:/run/php/php8.1-fpm.sock; \n" \
         "   } \n" \
         " } \n" \
         "" > /etc/nginx/sites-enabled/web.conf && \
    \
    echo \
         "hello world\n" \
         "" > /var/www/hello_world.php && \
    \
    echo \
         "<?php echo password_hash(\"hello_world\", PASSWORD_DEFAULT); ?>\n" \
         "" > /var/www/hash_password.php && \
    update-rc.d php8.1-fpm enable && \
    update-rc.d nginx enable

EXPOSE 8080/tcp
