### ImageMagick Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have ImageMagick installed


if ! command -v montage &>/dev/null && ! command -v convert &>/dev/null; then
    echo "ImageMagick is not installed. Not loading source.";
    return 0;
fi

function mkcontactsheet() {
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ $# -lt 2 ]; then
        echo 'USAGE: mkcontactsheet <input...> <output>'
        echo 'Example: mkcontactsheet img1.jpg img2.jpg output.jpg'
        return 0
    fi
    
    local output="${@: -1}"
    local inputs=("${@:1:$#-1}")
    
    montage -geometry 640x480\>+5+5 -frame 5 "${inputs[@]}" "$output" || {
        echo "Error: montage failed"
        return 1
    }
    echo "Wrote file: $output"
}

function mkcaption() {
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ $# -ne 2 ]; then
        echo 'USAGE: mkcaption <str> <file>'
        echo 'Example: mkcaption "Hello World" output.jpg'
        return 0
    fi
    
    local text="$1"
    local file="$2"
    
    convert -size 1024x200 -background white -pointsize 25 -fill black -gravity NorthWest caption:"$text" "$file" "$file" || {
        echo "Error: convert failed"
        return 1
    }
    echo "Wrote file: $file"
}

function addheaderimg() {
    if [ -z "$1" ] || [ "$1" == "--help" ] || [ $# -ne 3 ]; then
        echo 'USAGE: addheaderimg <headerimg> <bodyimg> <output>'
        echo 'Example: addheaderimg header.jpg body.jpg output.jpg'
        return 0
    fi
    
    local header="$1"
    local body="$2"
    local output="$3"
    
    convert "$header" "$body" -append "$output" || {
        echo "Error: convert failed"
        return 1
    }
    echo "Wrote file: $output"
}
