#!/bin/bash

DB_DIR="databases"

read -p "Enter database name: " db_name
if [[ -d "$DB_DIR/$db_name" ]]; then
    rm -r "$DB_DIR/$db_name"
    echo "Database '$db_name' dropped."
else
    echo "Database does not exist."
fi
