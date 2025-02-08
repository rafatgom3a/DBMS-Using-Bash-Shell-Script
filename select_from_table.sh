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

    #Select Menu
    echo "1- Select all"
    echo "2- Select specific record"
    read -p "Enter your choice (1 or 2) : " choice

    case $choice in
    1)
        clear
        #Printing Table Header + Seperator
        awk -F: '{if (NR==1){
                    for ( i=1; i<=NF; i++)
                        printf "|%-20s", $i

                    printf "\n"
                    
                    for ( i=1; i<=NF*21; i++)
                        printf "-"
                    printf "\n"
                }
        }' "$table_name"
        #Printing Table Data
        awk -F: '{if (NR>3){
                    for ( i=1; i<=NF; i++)
                        printf "|%-20s", $i
                    printf "\n"
                }
        }' "$table_name"
        ;;
    2)
        echo "Select a Column to select a specific value"
        #Listing Columns
        awk -F: '{if (NR==1){
            for ( i=1 ; i<=NF; i++)
                print i "-" $i
            }
        }' "$table_name"

        #Receiving & Validating Choice
        flag="true"
        while [[ "$flag" == "true" ]]; do
            flag="false"
            read -p "Enter a Column Number : " col_num
            if (( col_num <= 0 || col_num > num_of_cols )); then
                echo "Please choose a valid column number"
                flag="true"
            fi
        done

        #Getting the desired column's Type
        type=$(awk -F: -v col="$col_num" '{if (NR==2){
        print $col
        }}' "$table_name")

        #Recieving & Validating a value from user
        # read -p "Enter the value to serch for in Column number $col_num : " value
        flag="true"
        while [[ "$flag" == "true" ]]; do
            flag="false"
            if [[ "$type" == "int" ]]; then
                read -p "Enter the value to search for in Column number $col_num : " value
                if [[ ! "$value" =~ ^[0-9]+$ ]]; then
                    echo "Invalid Value!"
                    echo "The column you chose is an Integer type, it must contain numbers only "
                    flag="true"
                fi
            else
                read -p "Enter the value to search for in Column number $col_num : " value
                if [[ ! "$value" =~ ^[a-zA-Z]+( [a-zA-Z]+)*$ ]]; then
                    echo "Invalid Value!"
                    echo "The column you chose is a String type, it must start and end with Alphapetics only"
                    echo "it must also contain Alphapetics & Spaces only "
                    flag="true"
                fi
            fi
        done

        value_exist=$(cut -d: -f"$col_num" "$table_name" | tail -n +4 | grep -Fxq "$value" && echo 1 || echo 0)

        #Printing the Output
        case $value_exist in
        0)
            echo "This value doesn't exist in table $table_name"
            ;;
        1)
            #Printint Table Header & Seperator
            awk -F: '{if (NR==1){
                    for ( i=1; i<=NF; i++)
                        printf "|%-20s", $i

                    printf "\n"
                    
                    for ( i=1; i<=NF*21; i++)
                        printf "-"
                    printf "\n"
                }
            }' "$table_name"
            #Printing desired Record
            awk -F: -v col="$col_num" -v val="$value" '{if (NR>3 && $col==val){
                        for ( i=1; i<=NF; i++)
                            printf "|%-20s", $i
                        printf "\n"
                    }
            }' "$table_name"
            ;;
        esac
        ;;
    *)
        echo -e "Invalid choice."
        echo -e "Please select a valid option."
        ;;
    esac

fi
