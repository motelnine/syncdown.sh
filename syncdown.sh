#!/bin/bash

# Shutdown command to be executed
#SHUTDOWN_COMMAND='shutdown -h now'
SHUTDOWN_COMMAND='echo "shutdown -h now"'

# Location of folders file (one folder per line)
FOLDER_FILE='folders.txt'

# Git commit message
COMMIT_MESSAGE='syncdown.sh auto commit'

# Git error message
GIT_ERROR_MESSAGE='A git error occured. Dropping back to console...'

# Sync console container opene
opencontainer () {
	echo -e "\n----------------[ Sync ]----------------\n"
	echo "Syncing folder [$FOLDER] ..."
}

# Sync console container close
closecontainer () {
	echo -e "\n---------------------------------------\n"
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
	closecontainer

	GIT_CODE=$?

	if [[ $GIT_CODE -ne 0 ]]
	then
		echo "Git error: $GIT_CODE. Dropping to console."
		exit 1
	fi


done

if [[ $? -ne 0 ]]; then
	echo $GIT_ERROR_MESSAGE
else
	echo `$SHUTDOWN_COMMAND`
fi
