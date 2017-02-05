### Bash Profile: Fun Stuff
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Version: 1.0
### Just a bunch of "fun" things you can add to your bash profile

# Play ascii starwars
alias starwars='telnet towel.blinkenlights.nl';

# Print the current startdate
function stardate() {
	if [ "$1" == "--alternate" -o "$1" == "-a" ]; then
		date +%Y.%j | sed 's/\.0*/\./';
	else
		date +%Y%d.%m | sed 's/\.0*/\./';
	fi
}
