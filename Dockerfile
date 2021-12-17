FROM ubuntu:20.04

RUN \
# Update and get dependencies
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
    curl \
    nginx \
    php8.1 php8.1-fpm php8.1-cli \
    nodejs \
    golang && \
    \
# Add Folder to web
    mkdir -p /var/www

RUN \
# Setup PHP
    echo "server {\n" \
         "  listen 8080;" \
         "  root /var/www;\n" \
         "  location ~ /*.php$ {\n" \
         "    include snippets/fastcgi-php.conf\n" \
         "    fastcgi_pass unix:/run/php/php8.1-fpm.sock;\n" \
         "  }\n" \
         "  \n" \
         "  location ~ .go$ {\n" \
         "    fastcgi_pass 127.0.0.1:8081;\n" \
         "  }\n" \
         "}\n" \
         "" > /etc/nginx/nginx.conf && \
    service restart nginx

EXPOSE 8080/tcp
