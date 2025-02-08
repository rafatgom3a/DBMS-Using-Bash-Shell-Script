#!/bin/bash

DB_DIR="databases"

read -p "Enter database name: " db_name
    if [[ -d "$DB_DIR/$db_name" ]]; then
        cd "$DB_DIR/$db_name"
        #./table_menu.sh
        ../../table_menu.sh
    else
        echo "Database does not exist."
    fi

