### Handbrake Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have HandbrakeCLI installed

if ! command -v HandBrakeCLI &>/dev/null; then
    echo "HandBrakeCLI is not installed. Not loading source.";
    return 0;
fi

function mkh265() {
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ $# -lt 1 ] || [ $# -gt 2 ]; then
        echo 'USAGE: mkh265 <input> [res]'
        echo '  res: 720p (default) or 1080p'
        echo 'Example: mkh265 video.mov 1080p'
        return 0
    fi
    
    local input="$1"
    local res="${2:-720p}"
    
    # Validate input file exists
    if [ ! -f "$input" ]; then
        echo "Error: input file not found: $input"
        return 1
    fi
    
    # Validate resolution
    if [ "$res" != "720p" ] && [ "$res" != "1080p" ]; then
        echo "Error: invalid resolution. Use 720p or 1080p"
        return 1
    fi
    
    # Extract filename without extension
    local dest="${input%.*}"
    
    HandBrakeCLI -Z "Matroska/H.265 MKV ${res}30" -i "$input" -o "${dest}.mkv" || {
        echo "Error: HandBrakeCLI failed"
        return 1
    }
    echo "Wrote file: ${dest}.mkv"
}
