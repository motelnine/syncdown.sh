
Create a file `~/.config/syncdown/folders.conf`

Edit the file and add a list of folders using the full path to auto-sync and the git push aruments seperated by a `:` character" e.g.
```
/home/user/Projects/project1:origin master
/home/user/Projects/project1:origin dev
```
To sync the folders without shuting down the `--sync-only` argument can be used:
```
syncdown.sh --sync
``` 

You may wish to create a symbolic link
```
ln -s <path-to-syncdown>/syncdown.sh /bin/syncdown
```

You may also wish to alias your shutdown command to this script in your preferred shell.
```
alias shutdown="syncdown --sync"
```

To force using syncdown you can add these aliases to your `.bashrc` file:
```
alias shutdown='echo "Do not run as root. Use syncdown"'
alias restart='echo "Do not run as root. Use syncdown"'
alias reboot='echo "Do not run as root. User syncdown"'
```

To sync on startup link `syncup.sh` to `/bin/syncup`
```
ln -x <path-to-syncup.sh>/syncup.sh /bin/syncup
```

Run this command at startup (e.g. i3.config) to execute startup sync in xcfe4-terminal window:
```
xfce4-terminal --hold -x '/bin/syncup'
```
