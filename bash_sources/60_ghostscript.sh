### GhostScript functions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

if [ -z "$(which gs 2>/dev/null)" ]; then
    echo "GhostScript not installed. Skipping source.";
    return 1;
fi

# Run an encrypted pdf through a print function to decrypt it
function decrypt_pdf () {
        if [ -z "$1" ]; then
            echo "USAGE: decrypt_pdf PDF";
        else
    output=$(echo $1 | sed 's/\.pdf/_decrypted\.pdf/');
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output" -dPDFSETTINGS=/prepress -f "$1";
        fi
}

# Convert a PDF to jpg files
function pdf2jpg () {
        if [ -z "$1" ]; then
            echo "USAGE: pdf2jpg PDF";
        else
    outname=$(echo "$1" | sed 's/\.pdf//');
    curpath=$(dirname "$1");
    if [ ! -d "$curpath/$outname" ]; then
        mkdir -p "$curpath/$outname";
    fi
    gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -dJPEGQ=100 -sOutputFile="${curpath}/${outname}/${outname} %03d.jpg" "$1";
        fi
}