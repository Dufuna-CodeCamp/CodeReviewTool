#!/bin/bash

NONE='\033[00m'
BOLD='\x1b[1m'
UNDERLINE='\033[4m'
ITALIC='\x1b[3m'

echo -n "Enter First Name : "
read first_name

echo -n "Enter Last Name : "
read last_name

set_folder() {
    first_name=$(echo "$first_name" | tr -s '[:upper:]' '[:lower:]')
    first_letter=$(echo "${last_name:0:1}" | tr -s '[:lower:]' '[:upper:]')
    last_substring=$(echo "${last_name:1}" | tr -s '[:upper:]' '[:lower:]')

    folder_name="$first_name$first_letter$last_substring"
}

set_folder

submission_directory="$PWD/../../submissions"
path_to_folder="$submission_directory/$folder_name"
path_to_aboutMe_folder="$path_to_folder/aboutMe"
path_to_file_with_extension="$path_to_aboutMe_folder/aboutMe.txt"
path_to_file_without_extension="$path_to_aboutMe_folder/aboutMe"
path_to_log="$submission_directory/../tests/logfile.json"

check_folder_existence() {
    if [ -d "$path_to_folder" ]
    then
        folder_exists=1
    else
        folder_exists=0
        echo "Your folder should be named in camel case with your First and Last name."
        echo "Ensure your folder is located in the submissions directory."
    fi
}

check_aboutMe_folder_existence() {
    if [ -d "$path_to_aboutMe_folder" ]
    then
        aboutMe_folder_exists=1
    else
        aboutMe_folder_exists=0
        echo "Your folder should be named \"aboutMe\" and located in the folder with your First and Last name."
    fi
}

check_file_existence() {
    if [ -s "$path_to_file_with_extension" ]
    then
        file_exists=1
    else
        if [ -s "$path_to_file_without_extension" ]
        then
            file_exists=1
        else
            file_exists=0
            echo "1. You should create a text file named \"aboutMe.txt\" or \"aboutMe\"."
            echo "2. Ensure your file is located in the \"aboutMe\" folder you have created."
            echo "3. Ensure your text file contains text."
        fi
    fi
}

write_json_response() {
    echo "{" > $path_to_log
    echo "  \"stats\": {" >> $path_to_log
    echo "    \"tests\": $total_tests," >> $path_to_log
    echo "    \"passes\": $no_of_passes," >> $path_to_log
    echo "    \"failures\": $no_of_failures" >> $path_to_log
    echo "  }" >> $path_to_log
    echo "}" >> $path_to_log
}

write_output() {
    echo -e "${ITALIC}Total number of tests:${NONE} ${BOLD}$total_tests${NONE}"
    echo -e "${ITALIC}Passed tests:${NONE} ${BOLD}$no_of_passes${NONE}"
    echo -e "${ITALIC}Failed tests:${NONE} ${BOLD}$no_of_failures${NONE}"
}

no_of_passes=0
no_of_failures=0

check_folder_existence
check_aboutMe_folder_existence
check_file_existence

if [ $folder_exists -eq 1 ]
then
    no_of_passes=$((no_of_passes+1))
else
    no_of_failures=$((no_of_failures+1))
fi

if [ $aboutMe_folder_exists -eq 1 ]
then
    no_of_passes=$((no_of_passes+1))
else
    no_of_failures=$((no_of_failures+1))
fi

if [ $file_exists -eq 1 ]
then
    no_of_passes=$((no_of_passes+1))
else
    no_of_failures=$((no_of_failures+1))
fi

let total_tests=$no_of_passes+$no_of_failures

write_json_response
write_output