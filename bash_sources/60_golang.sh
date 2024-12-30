### GoLang Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have go installed

if [ -z $(which go 2> /dev/null) ]; then
	echo "golang is not installed. Not loading source.";
	return 1;
fi
export PATH=$PATH:$HOME/go/bin;
