### Bash Profile: Loader
### Author: Jesse Almanrode (jesse@almanrode.com)
### Version: 1.0
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

## Load files and links in ~/.sources.d/ that end in .sh
if [ -d ~/.sources.d ]; then
	for f in $(find ~/.sources.d \( -type f -o -type l \) -name *.sh); do
		source $f;
	done
else
	mkdir ~/.sources.d;
fi

## Functions that make the loader tick
function profile() {
case $1 in
	edit)
		if [ -z $2 ]; then
    		echo 'profile edit <source>';
    	else
      		vi ~/.sources.d/$2;
      		source ~/.bash_profile;
    	fi
	;;
	view)
		if [ -z $2 ]; then
    		echo 'profile view <source>';
    	else
      		less ~/.sources.d/$2;
    	fi
	;;
	reload)
		source ~/.bash_profile;
	;;
	load)
		if [ -z $2 ]; then
			echo 'profile load <source>';
		else
			if [ -f ~/.sources.d/$2 ]; then
				source ~/.sources.d/$2;
			else
				echo "Unable to load ~/.sources.d/$2";
			fi
		fi
	;;
	info)
		if [ -z $2 ]; then
			head ~/.bash_profile | grep -E '^### ';
			if [ -d ~/.sources.d ]; then
				echo "### Sources:";
				ls -1 ~/.sources.d/;
			fi
		else
			head ~/.sources.d/$2 | grep -E '^### ';
		fi
	;;
	*)
		echo 'profile [edit|info|reload|load|view]';
esac
}
