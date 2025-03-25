FROM ubuntu:latest

RUN apt update && apt -y upgrade

WORKDIR /app

#
# Nginx configuration block
#

COPY ./ngxhtml ./nginx

# nginx ubuntu prerequisites
RUN apt -y install curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# add nginx gpg keys
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# add nginx packages to apt
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# prefer nginx package repo over ubuntu's one
RUN echo "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# FINALLY install nginx with modules
RUN apt -y install nginx nginx-module-image-filter

COPY ./nginx /etc/nginx

EXPOSE 80

EXPOSE 443

ENTRYPOINT ["/bin/bash","-c","php -S 127.0.0.1:8001 -t nginx/blue & php -S 127.0.0.1:8000 -t nginx/red/ & nginx -g 'daemon off;'"]

