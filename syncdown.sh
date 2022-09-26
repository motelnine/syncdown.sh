#!/bin/bash

# Shutdown command to be executed
#SHUTDOWN_COMMAND='shutdown -h now'
SHUTDOWN_COMMAND='echo "shutdown -h now"'

# Location of folders file (one folder per line)
FOLDER_FILE='folders.txt'

COMMIT_MESSAGE='syncdown.sh auto commit'

openfolder () {
	echo "------------[Sync]------------"
	echo "Syncing folder: $FOLDER"
}

closefolder () {
	echo "------------------------------\n"
}

# Read folders
cat $FOLDER_FILE | while read line; do
	FOLDER=`echo "$line" | awk -F ':' '{print $1}'`
	PUSH_COMMAND=`echo "$line" | awk -F ':' '{print $2}'`

	openfolder $FOLDER

	`cd $FOLDER`
	git add .
	`git commit -m '$COMMIT_MESSAGE'`
	`git push $PUSH_COMMAND`

	if [[ $? -ne 0 ]]
	then
		echo "Git error: $?. Dropping to console."
		exit
	fi

	closefolder

done

`$SHUTDOWN_COMMAND`
