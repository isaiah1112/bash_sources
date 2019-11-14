### Bash Profile: ImageMagick Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ImageMagick installed


if [ -z $(which montage 2> /dev/null) -a -z $(which convert 2> /dev/null) ]; then
	echo "ImageMagick is not installed. Not loading source.";
	return 1;
fi

function mkcontactsheet() {
	if [ -z "$1" -o "$1" == "--help" -o $# -ne 2 ]; then
			echo 'USAGE: mkcontactsheet <input> <output>';
			return 0;
	fi
	montage -geometry +5+5 -tile 3x5 -frame 5 "$1" "$2";
	echo "Wrote file: $2";
}

function mkcaption() {
	if [ -z "$1" -o "$1" == "--help" -o $# -ne 2 ]; then
			echo 'USAGE: mkcaption <str> <file>';
			return 0;
	fi
	convert -size 1024x160 -background white -pointsize 25 -fill black -gravity NorthWest caption:"$1" -flatten "$2";
	echo "Wrote file: $2"
}
