#!/bin/bash

echo "Available tables:"
ls

read -p "Enter the table name to delete from: " table_name

if [[ ! -f "$table_name" ]]; then
    echo "Error: Table '$table_name' does not exist."
    exit 1
fi


pr_key=$(awk 'NR==3 {print $1}' "$table_name")
columns=($(awk -F: 'NR==1 {for (i=1; i<=NF; i++) print $i}' "$table_name"))


if (( $(wc -l < "$table_name") <= 3 )); then
    echo "Error: No data found in table '$table_name'."
    exit 1
fi


echo "Current Data:"
awk -F: 'NR>3 {print $0}' "$table_name"


read -p "Enter the value of the primary key to delete: " key_value


if ! grep -q "^$key_value:" "$table_name"; then
    echo "Error: No record found with primary key '$key_value'."
    exit 1
fi

sed -i "/^$key_value:/d" "$table_name"

echo "Record with Primary Key '$key_value' deleted successfully!"
