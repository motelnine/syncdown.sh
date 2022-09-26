#!/bin/bash

# Shutdown command to be executed
#SHUTDOWN_COMMAND='shutdown -h now'
SHUTDOWN_COMMAND='echo "shutdown -h now"'

# Location of folders file (one folder per line)
FOLDER_FILE='folders.txt'

# Git commit message
COMMIT_MESSAGE='syncdown.sh auto commit'

# Error count
ERRORS=0

# Sync console container opene
opencontainer () {
	echo "------------[Sync]------------"
	echo "Syncing folder: $FOLDER"
}

# Sync console container close
closecontainer () {
	echo "------------------------------\n"
}

# Read folders
cat $FOLDER_FILE | while read line; do
	FOLDER=`echo "$line" | awk -F ':' '{print $1}'`
	PUSH_COMMAND=`echo "$line" | awk -F ':' '{print $2}'`

	opencontainer $FOLDER

	`cd $FOLDER`
	git add .
	`git commit -m '$COMMIT_MESSAGE'`
	`git push $PUSH_COMMAND`

	GIT_CODE=$?

	if [[ $GIT_CODE -ne 0 ]]
	then
		echo "Git error: $GIT_CODE. Dropping to console."
		exit 1
	fi

	closecontainer

done

echo `$SHUTDOWN_COMMAND`
