### Bash Profile: Python Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have Python installed

if [ -z $(which python 2>/dev/null) ]; then
	echo "python is not installed. Not loading source.";
	return 1;
fi

alias json='python -mjson.tool';
alias httpserver='python -m SimpleHTTPServer';


function pipclean() {
if [ ! -f ./requirements.txt ]; then
	echo "requirements.txt file does not exist in $(pwd)";
else
	pip freeze | grep -v -f requirements.txt | xargs pip uninstall -y
fi
}

function pypi() {
case $1 in
	register)
		if [ ! -f setup.py ]; then
			echo "Unable to find setup.py in $(pwd)";
		else
			python setup.py register;
		fi
	;;
	upload)
		if [ ! -f setup.py ]; then
			echo "Unable to find setup.py in $(pwd)";
		else
			python setup.py sdist upload;
		fi
	;;
	*)
		echo "USAGE: pypi [--help|register|upload]";
	;;
esac
}
