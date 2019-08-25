### Bash Profile: Loader
### Author: Jesse Almanrode (jesse@almanrode.com)
### Version: 1.3
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

if [ -z $HOME ]; then
	echo "HOME is not set. Unable to continue.";
	return 1;
fi

## Load files and links in $HOME/.sources.d/ that end in .sh
if [ -d $HOME/.sources.d ]; then
	for f in $(find $HOME/.sources.d | grep ".sh$" | sort); do
		source $f;
	done
else
	mkdir $HOME/.sources.d;
fi

## Functions that make the loader tick
function profile() {
case $1 in
	edit)
		if [ -z $2 ]; then
    		echo 'profile edit <source>';
    	else
      		vi $HOME/.sources.d/$2;
      		source $HOME/.bash_profile;
    	fi
	;;
	view)
		if [ -z $2 ]; then
    		echo 'profile view <source>';
    	else
      		less $HOME/.sources.d/$2;
    	fi
	;;
	reload)
		source $HOME/.bash_profile;
	;;
	load)
		if [ -z $2 ]; then
			echo 'profile load <source>';
		else
			if [ -f $HOME/.sources.d/$2 ]; then
				source $HOME/.sources.d/$2;
			else
				echo "Unable to load $HOME/.sources.d/$2";
			fi
		fi
	;;
	info)
		if [ -z $2 ]; then
			head $HOME/.bash_profile | grep -E '^### ';
			if [ -d $HOME/.sources.d ]; then
				echo "### Sources:";
				ls -1 $HOME/.sources.d/;
			fi
		else
			head $HOME/.sources.d/$2 | grep -E '^### ';
		fi
	;;
	list)
		ls -1 $HOME/.sources.d/;
	;;
	*)
		echo 'profile [edit|info|reload|load|view|list]';
esac
}
