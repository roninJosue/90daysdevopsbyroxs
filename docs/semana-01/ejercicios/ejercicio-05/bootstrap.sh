#!/usr/bin/env bash

apt-get update -y
apt-get install -y nginx

# Habilita Nginx para que arranque con el sistema
systemctl enable nginx

# Reinicia para aplicar cambios
systemctl restart nginx
