#!/bin/bash

read -p "Enter table name: " table_name
    if [[ -f "$table_name" ]]; then
        rm "$table_name"
        echo "Table '$table_name' dropped."
    else
        echo "Table does not exist."
    fi
