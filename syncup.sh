#!/bin/bash

# Location of folders file (one folder per line)
FOLDER_FILE="$HOME/.config/syncdown/folders.conf"

# Git error message
GIT_ERROR_MESSAGE='A git error occured. Dropping back to console...'

# Sync console container open
opencontainer () {
	echo -e "\n----------------[ Sync ]----------------"
	echo "Syncing folder [$FOLDER] ..."
}

# Sync console container close
closecontainer () {
	echo -e "---------------------------------------\n"
}

# Read folders
cat $FOLDER_FILE | grep -vE '^[[:space:]]*$'\|'#' | while read line; do
	FOLDER=`echo "$line" | awk -F ':' '{print $1}'`
	PULL_COMMAND=`echo "$line" | awk -F ':' '{print $2}'`

	opencontainer $FOLDER

	cd $FOLDER
	git pull `echo $PULL_COMMAND`
	GIT_CODE=$?

	closecontainer

	if [[ $GIT_CODE -ne 0 ]]
	then
		echo "Git error: $GIT_CODE. Dropping to console."
		exit 1
	fi
done

GIT_EXIT=$?

if [[ $GIT_EXIT -ne 0 ]]; then
	echo $GIT_ERROR_MESSAGE
else
	echo "Done."
fi
