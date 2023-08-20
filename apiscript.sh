#!/bin/bash
set nounset
set errexit
set pipefail
# do a request to https://queue-times.com/parks/4/queue_times.json and save the result to a json file in the formet of YYYY-MM-DD.json
# this script is called by a cronjob every 5 minutes

DIRECTORY="data"

timestamp(){
    date -u +'%Y%m%d-%H%M%S'|| echo;
}

# check if /data directory exists and create it if not
if [ ! -d "$DIRECTORY" ]; then
  mkdir $DIRECTORY
fi

# get the json data from the api
timestamp=$(timestamp);
curl -s https://queue-times.com/parks/54/queue_times.json > "$DIRECTORY"/data-"$timestamp".json 2>> log.txt;

# make the file read only
chmod 444 "$DIRECTORY"/data-"$timestamp".json 2>> log.txt;