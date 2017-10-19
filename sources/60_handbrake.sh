### Bash Profile: Handbrake Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have HandbrakeCLI installed

if [ -z $(which HandBrakeCLI 2> /dev/null) ]; then
	echo "HandBrakeCLI is not installed. Not loading source.";
	return 1;
fi

function mkh265() {
  dest=$(echo "${1}" | rev | cut -d . -f2- | rev);
  if [ "${2}" == "--1080p" ]; then
    res="1080p";
  else
    res="720p";
  fi
  HandBrakeCLI -Z "H.265 MKV ${res}30" -i "${1}" -o "${dest}.mkv";
}
