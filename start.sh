#!/bin/bash

# Set root login password
echo "Setting root login password: $ROOT_PASSWORD"
echo "root:$ROOT_PASSWORD" | chpasswd

# Launch supervisor
supervisord -n