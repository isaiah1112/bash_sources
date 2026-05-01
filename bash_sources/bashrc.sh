### Author: Jesse Almanrode (jesse@almanrode.com)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

## Load files in $HOME/.bash_sources.d/ that end in .sh
BASH_SOURCES="${HOME}/.bash_sources.d"

if [[ -d "$BASH_SOURCES" ]]; then
    for f in "$BASH_SOURCES"/*.sh; do
        [[ -e "$f" ]] && source "$f"
    done
else
    echo "Please run 'install.sh bashrc'"
    return 1
fi

## Functions that make the loader tick
profile() {
    local cmd="${1:-}"
    local arg="${2:-}"

    case "$cmd" in
        edit)
            if [[ -z "$arg" ]]; then
                echo 'profile edit <source>'
            else
                vi "$BASH_SOURCES/$arg"
                source "${HOME}/.bash_profile"
            fi
            ;;
        view)
            if [[ -z "$arg" ]]; then
                echo 'profile view <source>'
            else
                less "$BASH_SOURCES/$arg"
            fi
            ;;
        reload)
            source "${HOME}/.bash_profile"
            ;;
        list)
            ls -1 "$BASH_SOURCES/"
            ;;
        *)
            echo 'profile [edit|reload|view|list]'
            ;;
    esac
}
