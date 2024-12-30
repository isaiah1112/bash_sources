### Author: Jesse Almanrode (jesse@almanrode.com)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

## Load files and links in $HOME/.sources.d/ that end in .sh
BASH_SOURCES="$HOME/.bash_sources.d";

if [ -d $BASH_SOURCES ]; then
	for f in $(find $BASH_SOURCES | grep ".sh$" | sort); do
		source $f;
	done
else
	echo "Please run 'install.sh bashrc'";
	return 1;
fi

## Functions that make the loader tick
function profile() {
case $1 in
	edit)
		if [ -z $2 ]; then
    		echo 'profile edit <source>';
    	else
      		vi $BASH_SOURCES/$2;
      		source $HOME/.bash_profile;
    	fi
	;;
	view)
		if [ -z $2 ]; then
    		echo 'profile view <source>';
    	else
      		less $BASH_SOURCES/$2;
    	fi
	;;
	reload)
		source $HOME/.bash_profile;
	;;
	list)
		ls -1 $BASH_SOURCES/;
	;;
	*)
		echo 'profile [edit|reload|view|list]';
esac
}
