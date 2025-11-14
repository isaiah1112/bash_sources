### ffmpeg Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ffmpeg installed


if [ -z $(which ffmpeg 2> /dev/null) ]; then
	echo "ffmpeg is not installed. Not loading source.";
	return 1;
fi

alias ffplay='ffplay -loglevel quiet -autoexit';

# Reverse a video clip
function ffreverse() {
	if [ -z "$1" -o "$1" == "--help" ]; then
			echo 'USAGE: ffreverse <file>';
			return 0;
	fi
	ffmpeg -i "$1" -vf reverse -af areverse "reversed_$1";
}

# function for downloading m3u8 content to an mp4 file
function m3u8_download() {
	if [ -z "$1" -o "$1" == "--help" ]; then
			echo 'USAGE: m3u8_download <url> <file>';
			return 0;
	fi
	ffmpeg -hide_banner -i "$1" -c copy -bsf:a aac_adtstoasc "$2";
}

# function to create a timelapse video from a list of images
function mktimelapse() {
	if [ -z "$1" -o "$1" == "--help" ]; then
		echo "USAGE: mktimelapse <files...> [fps] [preset]";
		return 0;
	fi
	if [ -n "$2" ]; then
		fps=$2;
	else
		fps=15;
	fi
	if [ -n "$3" ]; then
		preset=$3;
	else
		preset='medium';
	fi
	ffmpeg -r $fps -pattern_type glob -i "$1" -vf "scale=1920:-1" -vcodec libx264 -preset $preset -crf 15 -pix_fmt yuv420p ./timelapse.mp4;
}

# create a timelapse video from a video file
function mkvlapse() {
	if [ -z "$1" -o "$1" == "--help"]; then
		echo "USAGE: mkvlapse <file>";
		return 0;
	fi
	name=$(echo "$1" | rev | cut -d '.' -f2- | rev);
	ffmpeg -i "$1" -filter:v "setpts=0.5*PTS" -an ${name}_timelapse.mp4;
}
