FROM ubuntu:24.04
RUN apt-get update && apt-get install -y nginx openssh-server openssl && rm -rf /var/lib/apt/lists/* \
 && mkdir /run/sshd \
 && sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=localhost" \
    -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
 && printf 'server {\n listen 443 ssl default_server;\n ssl_certificate /etc/ssl/certs/nginx.crt;\n ssl_certificate_key /etc/ssl/private/nginx.key;\n root /var/www/html;\n index index.html index.nginx-debian.html;\n}\n' > /etc/nginx/conf.d/ssl.conf
EXPOSE 22 80 443
CMD ["sh","-c","echo \"root:${SSH_PASSWORD:?set SSH_PASSWORD}\" | chpasswd && service ssh start && exec nginx -g 'daemon off;'"]
