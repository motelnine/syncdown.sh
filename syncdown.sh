#!/bin/bash
FOLDER_COLOR='\033[0;36m'
RESET_COLOR='\033[0;0m'
OK_COLOR='\033[0;32m'
LINE_COLOR='\033[0;37m'
ERROR_COLOR='\033[0;31m'

# Shutdown command to be executed after sync
SHUTDOWN_COMMAND='shutdown -h now'

# Restart command to be executed after sync
RESTART_COMMAND='reboot -h now'

# Location of folders file (one folder per line)
FOLDER_FILE="$HOME/.config/syncdown/folders.conf"

# Git commit message
COMMIT_MESSAGE='syncdown.sh auto commit'

# Git error message
GIT_ERROR_MESSAGE='A git error occured. Dropping back to console...'

# Sync console container open
opencontainer () {
	echo -e "\n---------------------------------------"
	echo -e "Syncing [${FOLDER_COLOR}${FOLDER}${RESET_COLOR}${RESET_COLOR}]..."
}

# Sync console container close
closecontainer () {
	echo -e "---------------------------------------\n"
}

# Read folders
cat $FOLDER_FILE | grep -vE '^[[:space:]]*$'\|'#' | while read line; do
	FOLDER=`echo "$line" | awk -F ':' '{print $1}'`
	PUSH_COMMAND=`echo "$line" | awk -F ':' '{print $2}'`

	opencontainer $FOLDER

	cd $FOLDER
	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push `echo $PUSH_COMMAND`
	GIT_CODE=$?

	if [[ $GIT_CODE -ne 0 ]]
	then
		echo "Status: [${ERROR_COLOR}${GIT_CODE}${RESET_COLOR}] Dropping to console!"
		exit 1
	else
		echo -e "Status: [${OK_COLOR}OK${RESET_COLOR}]"
	fi

	closecontainer
done

GIT_EXIT=$?

if [[ $GIT_EXIT -ne 0 ]]; then
	echo $GIT_ERROR_MESSAGE
else
	case $1 in
		"--sync")
			echo "Done."
		 	;;
		"--restart")
			`$RESTART_COMMAND`
			;;
		*)
			`$SHUTDOWN_COMMAND`
			;;
	esac

fi
