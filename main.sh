#!/bin/bash
set nounset
set errexit
set pipefail
# check if data folder exists in current directory
if [ ! -d data ]; then
    mkdir data
fi
# check if log.txt exists in current directory
if [ ! -f log.txt ]; then
    touch log.txt
    chmod 777 log.txt
fi
#check if pip is installed
if ! [ -x "$(command -v pip)" ]; then
    sudo apt-get install python3-pip -y
fi
# check if the content of requirements.txt is in pip list
if ! [ -x "$(pip list | grep -Ff requirements.txt)" ]; then
    sudo pip install -q -r requirements.txt
fi

if [ ! -x ./apiscript.sh ]; then
    chmod +x ./apiscript.sh >> log.txt
fi
sudo ./apiscript.sh
wait

if [ ! -x ./convertToCSV.sh ]; then
    chmod +x ./convertToCSV.sh >> log.txt
fi
sudo ./convertToCSV.sh
wait
# run the python script
# check if analyse.py is executable
if [ ! -x ./analyse.py ]; then
    sudo chmod +x ./analyse.py
fi
python3 analyse.py >> log.txt