### GhostScript Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

if ! command -v gs &>/dev/null; then
    echo "GhostScript not installed. Skipping source.";
    return 0;
fi

# Run an encrypted pdf through a print function to decrypt it
function decrypt_pdf() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo 'USAGE: decrypt_pdf <input.pdf>'
        echo 'Example: decrypt_pdf document.pdf'
        return 0
    fi
    
    local input="$1"
    
    if [ ! -f "$input" ]; then
        echo "Error: file not found: $input"
        return 1
    fi
    
    local output="${input%.pdf}_decrypted.pdf"
    
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output" -dPDFSETTINGS=/prepress -f "$input" || {
        echo "Error: GhostScript failed"
        return 1
    }
    echo "Wrote file: $output"
}

# Convert a PDF to jpg files
function pdf2jpg() {
    if [ -z "$1" ] || [ "$1" == "--help" ]; then
        echo 'USAGE: pdf2jpg <input.pdf>'
        echo 'Example: pdf2jpg document.pdf'
        return 0
    fi
    
    local input="$1"
    
    if [ ! -f "$input" ]; then
        echo "Error: file not found: $input"
        return 1
    fi
    
    local outname="${input%.pdf}"
    local curpath="$(dirname "$input")"
    local outdir="${curpath}/${outname}"
    
    if [ ! -d "$outdir" ]; then
        mkdir -p "$outdir" || {
            echo "Error: failed to create output directory"
            return 1
        }
    fi
    
    gs -q -dNOPAUSE -dBATCH -sDEVICE=jpeg -dJPEGQ=100 -sOutputFile="${outdir}/${outname} %03d.jpg" "$input" || {
        echo "Error: GhostScript failed"
        return 1
    }
    echo "Wrote files to: $outdir/"
}