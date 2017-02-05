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
	--edit|-E)
		if [ -z $2 ]; then
    		echo 'profile --edit <source_script>';
    	else
      		vi ~/.sources.d/$2;
      		source ~/.bash_profile;
    	fi
	;;
	--reload|-R)
		source ~/.bash_profile;
	;;
	--info|-I)
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
		echo 'profile [--edit|--info|--reload]';
esac
}
