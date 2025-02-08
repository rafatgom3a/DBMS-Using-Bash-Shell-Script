#!/bin/bash

#Receiving TableName from user
read -p "Enter the Table's name : " table_name

#validating TableName
if [[ ! -f "$table_name" ]]; then
    echo "Invalid table name, Table $table_name doesn't exist"
    exit 1
else
    #Getting number of Columns
    num_of_cols=$(awk -F: '{if (NR==1){
    print NF
    }}' "$table_name")
    #Getting the desire column's Primary Key
    pri_key=$(awk -F: '{if (NR==3){
    print $0
    }}' "$table_name")


    again="yes"

    while [[ "$again" == "yes" ]]; do
        echo "" >> "$table_name" #Starting a new line so that it doesn't append the first field to the previous line

        for (( i=1; i<=$num_of_cols; i++ )); do
            #Getting the desired column's Name
            col_name=$(awk -F: -v iter="$i" '{if (NR==1){
            print $iter
            }}' "$table_name")
            #Getting the desired column's Type
            type=$(awk -F: -v col="$i" '{if (NR==2){
            print $col
            }}' "$table_name")
            #======================Validating Types of Inputs & Primary Key=====================
            flag="true"
            while [[ "$flag" == "true" ]]; do
                flag="false"
                #Validating Integer
                if [[ "$type" == "int" ]]; then
                    read -p "$col_name : " value
                    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
                        echo 'Invalid Value!'
                        echo "The column you chose is an Integer type, it must contain numbers only "
                        flag="true"
                    fi
                    #Validating PrimaryKey
                    if (( i == pri_key)); then
                        value_exist=$(cut -d: -f"$i" "$table_name" | tail -n +4 | grep -Fxq "$value" && echo 1 || echo 0)
                        if (( value_exist == 1)); then
                            echo 'This column is the Primary Key and this value already exists. You must enter a new value!.'
                            flag="true"
                        fi
                    fi
                #Validating String
                else
                    read -p "$col_name : " value
                    if [[ ! "$value" =~ ^[a-zA-Z]+( [a-zA-Z]+)*$ ]]; then
                        echo 'Invalid Value!'
                        echo "The column you chose is a String type, it must start and end with Alphapetics only"
                        echo "it must also contain Alphapetics & Spaces only "
                        flag="true"
                    fi
                    #Validating PrimaryKey
                    if (( i == pri_key)); then
                        value_exist=$(cut -d: -f"$i" "$table_name" | tail -n +4 | grep -Fxq "$value" && echo 1 || echo 0)
                        if (( value_exist == 1)); then
                            echo 'This column is the Primary Key and this value already exists. You must enter a new value!.'
                            flag="true"
                        fi
                    fi
                fi
            done

            #=========================Adding Value to Column=======================
            if (( i == num_of_cols )); then
                echo -n "$value" >> "$table_name"
            else
                echo -n "$value:" >> "$table_name"
            fi

        done
        flag="true"
        while [[ "$flag" == "true" ]];do
            flag="false"
            read -p "Do you want to add more records? (yes / no) : " again

            if [[ "$again" != "yes" && "$again" != "no" ]]; then
                echo 'Invalid Input! Enter yes or no'
                flag="true"
            fi
        done

    done
fi
