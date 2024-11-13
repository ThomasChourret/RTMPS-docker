# Start from the official NGINX image
FROM debian:stable

# Install necessary packages for building NGINX with required modules
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    wget \
    git \
    php8.2-fpm \
    && apt-get clean

# Download and install NGINX with the RTMP and Stream modules
RUN wget http://nginx.org/download/nginx-1.22.1.tar.gz && \
    tar -zxvf nginx-1.22.1.tar.gz && \
    cd nginx-1.22.1 && \
    git clone https://github.com/arut/nginx-rtmp-module.git && \
    ./configure --with-http_ssl_module --with-stream --with-stream_ssl_module --with-http_stub_status_module --add-module=nginx-rtmp-module && \
    make && \
    make install && \
    rm -rf nginx-1.22.1* && \
    rm -rf nginx-rtmp-module

# Clean up unnecessary files
RUN rm -rf /var/lib/apt/lists/*

# Create the necessary directories for NGINX
RUN mkdir -p /var/www/html && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/lib/nginx && \
    mkdir -p /var/run/nginx && \
    mkdir -p /auth/

# Copy the custom nginx.conf file into the container
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# copy php config file
RUN rm /etc/php/8.2/fpm/pool.d/www.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf

# copy PHP auth file
COPY auth.php /auth/auth.php

# copy keys.txt file
COPY keys.txt /auth/keys.txt

# copy ip play list
COPY ips.txt /auth/ips.txt

#copy PHP ip file
COPY play_auth.php /auth/playauth.php


#COPY allowed_keys.txt /etc/nginx/conf.d/allowed_keys.txt
#COPY whitelist_ips.txt /etc/nginx/conf.d/whitelist_ips.txt
#COPY generate_ips.sh /usr/local/bin/generate_ips.sh

# Make the script executable
#RUN chmod +x /usr/local/bin/generate_ips.sh

# Generate IP whitelist at build time
#RUN /usr/local/bin/generate_ips.sh

# Generate self-signed SSL certificate
#RUN mkdir -p /etc/nginx/ssl && \
#    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#    -keyout /etc/nginx/ssl/server.key \
#    -out /etc/nginx/ssl/server.crt \
#    -subj "/CN=localhost"

COPY ssl/server.key /etc/nginx/ssl/server.key
COPY ssl/server.crt /etc/nginx/ssl/server.crt

EXPOSE 1935 443 8080

CMD /usr/sbin/php-fpm8.2 -D && /usr/local/nginx/sbin/nginx -g 'daemon off;'

