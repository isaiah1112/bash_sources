### GoLang Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have go installed

if ! command -v go &>/dev/null; then
    echo "golang is not installed. Not loading source.";
    return 0;
fi

# Add Go bin to PATH if it exists and isn't already there
if [ -d "$HOME/go/bin" ]; then
    case ":$PATH:" in
        *":$HOME/go/bin:"*) ;;
        *) export PATH="$PATH:$HOME/go/bin" ;;
    esac
fi

# Optional: Show Go version
go version
