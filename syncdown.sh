#!/bin/bash

# Shutdown command to be executed
SHUTDOWN_COMMAND='shutdown -h now'

# Location of folders file (one folder per line)
FOLDER_FILE='folders.txt'

COMMIT_MESSAGE='syncdown.sh auto commit'

# Read folders
cat $FOLDER_FILE | while read line; do
	FOLDER=`echo "$line" | awk -F ':' '{print $1}'`
	PUSH_COMMAND=`echo "$line" | awk -F ':' '{print $2}'`

	`cd $FOLDER`
	git add .
	`git commit -m '$COMMIT_MESSAGE'`
	`git push $PUSH_COMMAND`

	if [[ $? -ne 0 ]]
	then
		die 1 "Git error. Dropping to console."
	fi
done
