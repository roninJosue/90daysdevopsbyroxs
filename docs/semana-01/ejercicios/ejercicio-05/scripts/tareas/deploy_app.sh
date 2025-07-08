#!/bin/bash

LOG="deploy_log.txt"

install_dependencies() {
  echo "Installing dependencies..." | tee -a $LOG
  sudo apt update && sudo apt install -y python3 python3-pip python3-venv nginx git >> $LOG 2>&1
  sudo systemctl enable nginx >> $LOG 2>&1
  sudo systemctl start nginx >> $LOG 2>&1
}

clone_app() {
  echo "Cloning the app..." | tee -a $LOG
  git clone -b booklibrary https://github.com/roxsross/devops-static-web.git >> $LOG 2>&1
  cd devops-static-web
}

configure_environment() {
  echo "Configuring virtual env..." | tee -a ../$LOG
  python3 -m venv venv && source venv/bin/activate
  pip install -r requirements.txt >> ../$LOG 2>&1
  pip install gunicorn >> ../$LOG 2>&1
}

configure_gunicorn() {
  echo "Starting Gunicorn..." | tee -a ../$LOG
  nohup venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 library_site:app >> ../$LOG 2>&1 &
  sleep 3
}

configure_nginx() {
  echo "Configuring Nginx..." | tee -a ../$LOG

  sudo rm -f /etc/nginx/sites-enabled/default

  sudo tee /etc/nginx/sites-available/booklibrary > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    location /static/ {
        alias $(pwd)/static/;
        expires 30d;
    }

    access_log /var/log/nginx/booklibrary_access.log;
    error_log /var/log/nginx/booklibrary_error.log;
}
EOF

  sudo ln -sf /etc/nginx/sites-available/booklibrary /etc/nginx/sites-enabled/
  sudo nginx -t >> ../$LOG 2>&1 && sudo systemctl reload nginx
}

verifying_services() {
  echo "Verifying services..." | tee -a ../$LOG

  # Verify Nginx
  if systemctl is-active --quiet nginx; then
    echo "✓ Nginx is active" | tee -a ../$LOG
  else
    echo "✗ Nginx is not active" | tee -a ../$LOG
  fi

  # Verify Gunicorn
  if pgrep -f "gunicorn.*library_site" > /dev/null; then
    echo "✓ Gunicorn is running" | tee -a ../$LOG
  else
    echo "✗ Gunicorn is not running" | tee -a ../$LOG
  fi

  # Verify port 8000
  if netstat -tlnp | grep -q ":8000"; then
    echo "✓ Port 8000 is in use" | tee -a ../$LOG
  else
    echo "✗ Port 8000 is not in use" | tee -a ../$LOG
  fi

  if curl -s http://127.0.0.1:8000 > /dev/null; then
    echo "✓ Gunicorn response correctly" | tee -a ../$LOG
  else
    echo "✗ Gunicorn is not responding" | tee -a ../$LOG
  fi
}

main() {
  echo "=== Starting Book Library's deploy ===" | tee $LOG
  install_dependencies
  clone_app
  configure_environment
  configure_gunicorn
  configure_nginx
  verifying_services

  echo "=== Deploy finished ===" | tee -a ../$LOG
  echo "Check $LOG for details." | tee -a ../$LOG
  echo "The app must be up in: http://$(hostname -I | awk '{print $1}')" | tee -a ../$LOG
}

main
