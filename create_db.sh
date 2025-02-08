#!/bin/bash

DB_DIR="databases"

read -p "Enter database name: " db_name
# Validation for database name
if [[ ! $db_name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    echo "Error: Invalid name. Names must start with a letter or underscore and contain only letters, digits, or underscores."
    exit 1
fi

if [[ -d "$DB_DIR/$db_name" ]]; then
    echo "Database already exists."
else
    mkdir -p "$DB_DIR/$db_name"
    echo "Database '$db_name' created."
fi

