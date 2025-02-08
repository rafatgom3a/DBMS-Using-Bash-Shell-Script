#!/bin/bash

read -p "Enter the table's neme to be created: " table_name
# Validation for table name
if [[ -f "$table_name" ]]; then
    echo "Table already exists."
else
    # if [[ -z "$table_name" || $table_name =~ ^[0-9] || $table_name =~ [^a-zA-Z_] ]]; then
    if [[ -z "$table_name" || $table_name =~ ^[0-9] || $table_name =~ [^a-zA-Z0-9_] ]]; then
        echo "Error: Invalid Table name. Names must start with a letter or underscore and contain only letters, digits, or underscores."
        exit 1
    else
        touch "$table_name"
        flag="true"

        #Table's Metadata

        #Number of Columns
        typeset -i num_of_cols
        while [[ $flag == "true" ]]; do
            flag="false"
            read -p "How many columns in table $table_name : " num_of_cols
            if [[ $num_of_cols =~ [^0-9] || $num_of_cols -le 0 || $num_of_cols -ge 20 ]]; then
                echo "Invalid Input, number of columns must be a number more than 0 and less than 20"
                flag="true"
            fi
        done
        # echo $num_of_cols >> "$table_name"
        echo "Table $table_name will have $num_of_cols columns"

        #Columns' names
        for ((i = 1; i <= num_of_cols; i++)); do
            flag="true"
            while [[ "$flag" == "true" ]]; do
                flag="false"
                read -p "Enter the Name of column number $i : " col_name
                if [[ -z "$col_name" || $col_name =~ ^[0-9] || $col_name =~ [^a-zA-Z0-9_] ]]; then
                    echo "Error: Invalid Column name. Names must start with a letter or underscore and contain only letters, digits, or underscores."
                    flag="true"
                fi
            done
            if (( i == num_of_cols )); then
                echo -n "$col_name" >> "$table_name"
            else
                echo -n "$col_name:" >> "$table_name"
            fi
        done

echo "" >> "$table_name"
        #Columns' types
        for ((i = 1; i <= num_of_cols; i++)); do
            flag="true"
            while [[ "$flag" == "true" ]]; do
                flag="false"
                read -p "Enter the Type of column number $i (string or int) : " col_type
                if [[ $col_type != "string" && $col_type != "int" ]]; then
                    echo "Error: Invalid Column type. Types must be either (string) or (int)."
                    flag="true"
                fi
            done
            if (( i == num_of_cols )); then
                echo -n "$col_type" >> "$table_name"
            else
                echo -n "$col_type:" >> "$table_name"
            fi
        done

        #Primary Key
        typeset -i pr_key
        echo "Select Primay Key : "
        awk -F: '{if (NR==1){
            for ( i=1 ; i<=NF; i++)
                print i "-" $i
            }
        }' "$table_name"

        flag="true"
        while [[ "$flag" == "true" ]]; do
            flag="false"
            read -p "Choose the Column Number : " pr_key
            if (( pr_key <= 0 || pr_key > num_of_cols )); then
                echo "Please choose a valid column number"
                flag="true"
            fi
        done

        echo "" >> $table_name
        echo "$pr_key" >> $table_name

        echo "Table '$table_name' created."
    fi
fi
