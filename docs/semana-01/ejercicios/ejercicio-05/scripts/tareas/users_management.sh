#!/bin/bash

source "$(dirname "$0")/functions.sh"

validate_user $1
create_group $2
create_user $1
