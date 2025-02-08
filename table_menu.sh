#!/bin/bash

# Table Menu
table_menu() {
    echo "Table Menu:"
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update Table"
    echo "8. Back to Main Menu"
    read -p "Enter your choice: " choice

    case $choice in
        1) ../../create_table.sh ;;
        2) ../../list_tables.sh ;;
        3) ../../drop_table.sh ;;
        4) ../../insert_into_table.sh ;;
        5) ../../select_from_table.sh ;;
        6) ../../delete_from_table.sh ;;
        7) ../../update_table.sh ;;
        8) return ;;
        *) echo "Invalid choice. Please try again." ;;
    esac

    table_menu
}

table_menu
