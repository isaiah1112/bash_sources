### ffmpeg Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ffmpeg installed

if ! command -v ffmpeg &>/dev/null; then
    echo "ffmpeg is not installed. Not loading source.";
    return 0;
fi

alias ffplay='ffplay -loglevel quiet -autoexit';

# Reverse a video clip
function ffreverse() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo 'USAGE: ffreverse <file>'
        echo 'Example: ffreverse video.mp4'
        return 0
    fi
    
    local input="$1"
    
    if [ ! -f "$input" ]; then
        echo "Error: file not found: $input"
        return 1
    fi
    
    local output="reversed_${input}"
    
    ffmpeg -hide_banner -i "$input" -vf reverse -af areverse "$output" || {
        echo "Error: ffmpeg failed"
        return 1
    }
    echo "Wrote file: $output"
}

# function for downloading m3u8 content to an mp4 file
function m3u8_download() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo 'USAGE: m3u8_download <url> <output>'
        echo 'Example: m3u8_download https://example.com/video.m3u8 output.mp4'
        return 0
    fi
    
    local url="$1"
    local output="$2"
    
    if [ -z "$output" ]; then
        echo "Error: output filename required"
        return 1
    fi
    
    ffmpeg -hide_banner -i "$url" -c copy -bsf:a aac_adtstoasc "$output" || {
        echo "Error: ffmpeg failed"
        return 1
    }
    echo "Wrote file: $output"
}

# function to create a timelapse video from a list of images
function mktimelapse() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo "USAGE: mktimelapse <glob_pattern> [fps] [preset]"
        echo "Example: mktimelapse '*.jpg' 30 fast"
        return 0
    fi
    
    local pattern="$1"
    local fps="${2:-15}"
    local preset="${3:-medium}"
    
    ffmpeg -r "$fps" -pattern_type glob -i "$pattern" -vf "scale=1920:-1" -vcodec libx264 -preset "$preset" -crf 15 -pix_fmt yuv420p ./timelapse.mp4 || {
        echo "Error: ffmpeg failed"
        return 1
    }
    echo "Wrote file: ./timelapse.mp4"
}

# create a timelapse video from a video file
function mkvlapse() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo 'USAGE: mkvlapse <file>'
        echo 'Example: mkvlapse video.mp4'
        return 0
    fi
    
    local input="$1"
    
    if [ ! -f "$input" ]; then
        echo "Error: file not found: $input"
        return 1
    fi
    
    local name="${input%.*}"
    local output="${name}_timelapse.mp4"
    
    ffmpeg -hide_banner -i "$input" -filter:v "setpts=0.5*PTS" -an "$output" || {
        echo "Error: ffmpeg failed"
        return 1
    }
    echo "Wrote file: $output"
}
