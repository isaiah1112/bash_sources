### Bash Profile: ffmpeg Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ffmpeg installed


if [ -z $(which ffmpeg 2> /dev/null) ]; then
	echo "ffmpeg is not installed. Not loading source.";
	return 1;
fi

alias ffjson='ffprobe -v quiet -print_format json -show_format -show_streams';
alias ffplay='ffplay -loglevel quiet -autoexit';

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

# function for printing specific details about a video in a specific show_format
function ffinfo () {
	if [ -z "$1" -o "$1" == "--help" ]; then
			echo 'USAGE: ffinfo <file>';
			return 0;
	fi
	video_stats=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=codec_name,duration,height,bit_rate "$1");
	bit_rate=$(echo "$video_stats" | grep bit_rate | grep -Eo '\d+');
	echo Filename: "$1";
	echo Format: $(echo "$video_stats" | grep codec_name | cut -d '=' -f2);
	echo Resolution: $(echo "$video_stats" | grep height | cut -d '=' -f2)p;
	if [ -n "$bit_rate" ]; then
		echo Bitrate: $(($bit_rate / 1000))kb/s;
	fi
	echo Duration: $(echo "$video_stats" | grep duration | cut -d '=' -f2 | cut -d '.' -f1)s;
	echo Filesize: $(ls -h "$1" | awk '{print $5}');
}

# function for converting mkv to mp4 (container only)
function mkv2mp4() {
    if [ -z "$1" -o "$1" == "--help" ]; then
        echo 'USAGE: mkv2mp4 <mkv> [mp4]';
        return 0;
    fi
    mkvname=$1;
    if [ -z "$2" ]; then
        mp4name=$(echo "$mkvname" | sed 's/\.mkv/\.mp4/g');
    else
        mp4name=$2
    fi
    ffmpeg -i "$mkvname" -c:v copy -c:a copy "$mp4name";
}

# function for converting mkv to wmv (container only)
function mkv2wmv() {
    if [ -z "$1" -o "$1" == "--help" ]; then
        echo 'USAGE: mkv2wmv <mkv> [wmv]';
        return 0;
    fi
    mkvname=$1;
    if [ -z "$2" ]; then
        wmvname=$(echo "$mkvname" | sed 's/\.mkv/\.wmv/g');
    else
        wmvname=$2
    fi
    ffmpeg -i "$mkvname" -c:v copy -c:a copy "$wmvname";
}

# function for converting avi to mp4 (container only)
function avi2mp4() {
    if [ -z "$1" -o "$1" == "--help" ]; then
        echo 'USAGE: avi2mp4 <avi> [mp4]';
        return 0;
    fi
    aviname=$1;
    if [ -z "$2" ]; then
        mp4name=$(echo "$aviname" | sed 's/\.avi/\.mp4/g');
    else
        mp4name=$2
    fi
    ffmpeg -i "$aviname" -c:v copy -c:a copy "$mp4name";
}

# function for building screencaptures every X seconds with timestamps
function mkscreens () {
 if [ -z "$1" -o "$1" == "--help" ]; then
   echo 'Usage: mkscreens <file> [step]'
   return 0;
 fi
 mkdir screens 2>/dev/null;
 if [ -n "$2" ]; then
   ffmpeg -hide_banner -i "$1" -vf "fps=1/$2,drawtext=fontfile=/Library/Fonts/Arial.ttf:fontsize=45:fontcolor=yellow:box=1:boxcolor=black:x=(W-tw)/2:y=H-th-10:text='%{pts\:hms}'" screens/img%03d.jpg;
 else
   ffmpeg -hide_banner -i "$1" -vf "fps=1/60,drawtext=fontfile=/Library/Fonts/Arial.ttf:fontsize=45:fontcolor=yellow:box=1:boxcolor=black:x=(W-tw)/2:y=H-th-10:text='%{pts\:hms}'" screens/img%03d.jpg;
 fi
}

# function for creating a gif preview of a media file
function mkpreviewgif () {
  if [ -z "$1" -o "$1" == "--help" ]; then
    echo 'Usage: mkpreviewgif <file> [--start|--stop|--step|--length|--fps|--scale]'
    return 0;
  fi
	start=60;
	stop=$(ffprobe -v quiet -show_format "$1" | grep duration | grep -Eo "\d+\.\d+" | cut -d '.' -f1);
	step=60;
	length=3;
	fps=5;
	scale=320;
  if [ $# -gt 1 ]; then
    for i in "${@:2}"; do
      case $i in
        --start=*)
          start=${i#*=};
        ;;
        --stop=*)
          stop=${i#*=};
        ;;
        --step=*)
          step=${i#*=};
        ;;
        --length=*)
          length=${i#*=};
        ;;
        --fps=*)
          fps=${i#*=};
        ;;
        --scale=*)
          scale=${i#*=};
        ;;
        *)
        echo "Unknown option $i";
        return 1;
      esac
    done
  fi
  mkdir /tmp/gifs;
  echo "Generating preview gifs for $1";
  while [ $start -lt $stop ]; do
    ffmpeg -v quiet -ss $start -t $length -i "$1" -vf "fps=$fps,scale=$scale:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 1 /tmp/gifs/$start.gif;
    echo file /tmp/gifs/$start.gif | tee -a /tmp/gifs/files.txt;
    let start=$start+$step;
  done
  echo "Compiling single gif from previews...";
  ffmpeg -v quiet -f concat -safe 0 -i /tmp/gifs/files.txt -ignore_loop 1 preview.gif;
  echo "Wrote preview.gif";
  rm -rf /tmp/gifs/;
}
