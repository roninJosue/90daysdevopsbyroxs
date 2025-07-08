#!/bin/bash

create_user() {
  sudo adduser $1
  echo "User '$1' created at: $(date)" >> users.log
}

create_group() {
  if ! getent group "$1" &>/dev/null; then
    echo "➕ Creating group '$1'..."
    sudo groupadd "$1"
    echo "Group '$1q' created at: $(date)" >> users.log
  fi
}

validate_user() {
  if id "$1" &>/dev/null; then
    echo "User '$1' exists"
    echo "User '$1' exists" >> users.log
    exit 1
  fi
}
