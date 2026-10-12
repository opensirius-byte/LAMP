FROM ubuntu:24.04
RUN apt-get update && apt-get install -y nginx openssh-server && rm -rf /var/lib/apt/lists/* && mkdir /run/sshd
EXPOSE 22 80
CMD service ssh start && nginx -g 'daemon off;'
