#!/bin/bash

DB_DIR="databases"
mkdir -p "$DB_DIR"

main_menu() {
    echo "Main Menu:"
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) ./create_db.sh ;;
        2) ./list_db.sh ;;
        3) ./connect_db.sh ;;
        4) ./drop_db.sh ;;
        5) exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac

    main_menu
}

main_menu
