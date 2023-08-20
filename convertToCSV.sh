#!/bin/bash
set nounset
set errexit
set pipefail

if [ ! -f data.csv ]; then
    echo "name,last_update,is_open,wait_time" > data.csv
fi


if ! [ -x "$(command -v dasel)" ]; then
    curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | grep -v .gz | cut -d\" -f 4)" -L -o dasel && chmod +x dasel >> log.txt
    sudo mv ./dasel /usr/local/bin/dasel
  echo "dasel installed by convertToCSV.sh" >> log.txt
fi

readfile(){
    
    if [ -z "$1" ]; then
        echo "No argument supplied to readfile() in convertToCSV.sh" >> log.txt
        exit 1
    fi
    amount="$(dasel -r json --file "$1" 'rides.all().count()')"

    
    for ((i = 0 ; i <= "$amount"-1 ; i++)); do
        item="$(dasel -r json --file "$1" 'rides' | dasel -r json "index($i)")"
        name="$(echo "$item" | dasel -r json 'name')"
        last_update="$(echo "$item" | dasel -r json 'last_updated')"
        is_open="$(echo "$item" | dasel -r json 'is_open')"
        wait_time="$(echo "$item" | dasel -r json 'wait_time')"
        echo "$name,$last_update,$is_open,$wait_time" >> data.csv
    done




   

}

latestfile="$(ls -t data | head -1)"


readfile "data/$latestfile"