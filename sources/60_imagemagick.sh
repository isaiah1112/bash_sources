### Bash Profile: ImageMagick Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ImageMagick installed


if [ -z $(which montage 2> /dev/null) ]; then
	echo "montage is not installed. Not loading source.";
	return 1;
fi

alias mkcontactsheet='montage -geometry +5+5 -tile 3x5 -frame 5';
