#!/bin/bash

#function to welcome the user
function welcome(){
    echo "Welcome to your phone book"
}
	
#function to add contact(-i)
function add_contact(){
	clear
    echo "-i Insert new contact name and number"    
	confirm=' '
    flag=0
    
    #check name is only letters 
    while [ $flag == 0 ]
    do
        read -p "NAME=" name
        if [[ "$name" =~ ^([A-Za-z]+ ?[A-Za-z]+)+$ ]]
        then 
            flag=1
        else
            echo "name should contain letters only"
        fi
    done
    
    #check name in DB
    grep "^#!!!NAME=$name|" $file_name

    if [ $? == 1 ]
    then
        #check number is only digits
        flag=0
        while [ $flag == 0 ]
        do
            read -p "PHONE=" number
            if [[ "$number" =~ ^[0-9]+$ ]]
            then 
                flag=1
            else 
                echo "number should contain numbers only"
            fi
        done 
            #insert name in DB
        echo "#!!!NAME=$name|PHONE=$number" >> $file_name
    	
    else
    clear
	grep "^#!!!NAME=$name|" $file_name | sed 's/^#!!!//'
        while [ "$confirm" != y ] && [ "$confirm" != n ]
        do
            echo "Do you want to add another number?y or n"
            read -p "answer=" confirm
        done
        if [ "$confirm" == y ]
        then
            #check the new number is digits only
            flag=0
            while [ $flag == 0 ]
            do
                read -p "PHONE=" number
                if [[ "$number" =~ ^[0-9]+$ ]]
                then 
                    flag=1
                else 
                    echo "number should contain numbers only"
                fi
            done  
        fi
            sed -i 's/\(^#!!!NAME='"$name"'\)/\1|PHONE='"$number"'/' $file_name
    fi
}
    
#function to view all contacts(-v)
function view_all_contacts(){
	clear
	grep '^#!!!' $file_name

    if [ $? == 1 ]
    then
        clear
        echo "-v View all saved contacts details"
    	echo "Your phone book is empty"
    else
	clear 
        echo "-v View all saved contacts details"
        grep '^#!!!' $file_name | sed 's/^#!!!//'
    fi    
}        

#function to search contact(-s)
#search by name & if it does not exist , there should be warning msg
function show_contact(){
	clear

	read -p "name=" name
	#check if name already exists then print its data 
    grep "^#!!!NAME=$name|" $file_name
    if [ $? == 1 ]
    then
	clear
	echo "-s Search by contact name"
    	echo "This name is not in your phone book"
    else
	clear
	echo "-s Search by contact name"
 	grep "^#!!!NAME=$name|" $file_name | sed 's/^#!!!//'
    fi
}




#function to delete all contacts(-e)
function delete_all_contacts(){
	clear
    echo "-e Delete all records"
	confirm=' '
	while [ "$confirm" != y ] && [ "$confirm" != n ]
    do
		echo "Are you sure you want to delete all contacts?y or n"
        read -p "answer=" confirm
    done
	if [ "$confirm" == y ]
    then
        sed -i '/^#!!!/d' $file_name
		echo "All contacts have been deleted"
	fi		
}

#function to delete contact(-d)
#if it does not exist , warning msg
function delete_contact(){
	clear
	confirm=' '
	read -p "NAME=" name
	#check if name already exists then print its data
    grep "^#!!!NAME=$name|" $file_name
    if [ $? == 1 ]
    then
	clear
   	echo "-d Delete only one contact name"
    	echo "This name is not in your phone book"
    else
	clear
    echo "-d Delete only one contact name"
	grep "^#!!!NAME=$name|" $file_name | sed 's/^#!!!//'
    while [ "$confirm" != y ] && [ "$confirm" != n ]
    do
		echo "Are you sure you want to delete this contact?y or n"
        read -p "answer=" confirm
    done
	if [ "$confirm" == y ]
    then
        sed -i '/^#!!!NAME='"$name"'/d' $file_name
		echo "The contact has been deleted"
	fi
	
    fi

}







file_name=$0
options_number="$#"
if [ $options_number == 0 ]
then
    echo "To run this script, you should use one of these options"
    echo "-i Insert new contact name and number"
    echo "-v View all saved contacts details"
    echo "-s Search by contact name"
    echo "-e Delete all records"
    echo "-d Delete only one contact name"
elif [ $options_number == 1 ]
then
        welcome
        case $1 in
        "-i")
            add_contact;;
        "-v")
            view_all_contacts;;
        "-s")
            show_contact;;
        "-e")
            delete_all_contacts;;
        "-d")
            delete_contact;;
        *)
            echo "This option $1 is not one of the available options";;
        esac
else
    echo "ERROR:Too many options"
fi    
    
    



           
#################################################################
