#!/bin/bash

echo "Available tables:"
ls

read -p "Enter the table name to update: " table_name

if [[ ! -f "$table_name" ]]; then
    echo "Error: Table '$table_name' does not exist."
    exit 1
fi


pr_key=$(awk -F: 'NR==3 {print $1}' "$table_name")
columns=($(awk -F: 'NR==1 {for (i=1; i<=NF; i++) print $i}' "$table_name"))

if (( $(wc -l < "$table_name") <= 3 )); then
    echo "Error: No data found in table '$table_name'."
    exit 1
fi


echo "Current Data:"
awk -F: 'NR>3 {print $0}' "$table_name"


read -p "Enter the value of the primary key to update: " key_value

if ! grep -q "^$key_value:" "$table_name"; then
    echo "Error: No record found with primary key '$key_value'."
    exit 1
fi


read -p "Enter the number of the column to update: " col_number
col_number=$((col_number - 1))  # Convert to 0-based index

if [[ $col_number -lt 0 || $col_number -ge ${#columns[@]} ]]; then
    echo "Invalid column number."
    exit 1
fi

# Get Column Type
col_type=$(awk -F: -v col=$((col_number+1)) 'NR==2 {print $col}' "$table_name")

# Get New Value
read -p "Enter the new value for ${columns[$col_number]}: " new_value

# Validate Input Type
if [[ "$col_type" == "int" && ! "$new_value" =~ ^[0-9]+$ ]]; then
    echo "Error: Column '${columns[$col_number]}' requires an integer value."
    exit 1
fi

# Update the Record
awk -F: -v key="$key_value" -v col=$((col_number+1)) -v new_val="$new_value" '
BEGIN {OFS=FS}
NR>3 && $1 == key {
    $col = new_val
    found = 1
}
{print}
END {
    if (!found) print "Error: Record not found."
}
' "$table_name" > temp_table && mv temp_table "$table_name"

echo "Record updated successfully!"
