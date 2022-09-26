
Create a file `~/.config/syncdown/folders.conf`

Edit the file and add a list of folders using the full path to auto-sync and the git push aruments seperated by a `:` character" e.g.
```
/home/user/Projects/project1:origin master
/home/user/Projects/project1:origin dev
```
To sync the folders without shutind down the `--sync-only` argument can be used:
```
syncdown.sh --sync-only
``` 

You may wish to alias your shutdown command to this script in your preferred shell.
