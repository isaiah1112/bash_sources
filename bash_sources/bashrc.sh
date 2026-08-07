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

# define autocomplete function
_profile_autocomplete() {
  case ${COMP_CWORD} in
    1) # we only have one word, so text looks something like "profile ed"
      COMPREPLY=($(compgen -W "edit reload view list" -- ${COMP_WORDS[COMP_CWORD]}))
      ;;
    2) # we're working on a second word, like "profile edit some"
      case ${COMP_WORDS[COMP_CWORD-1]} in
        edit | view) #completables!
          # BASH_SOURCES is defined by the bashrc; now use it to find the files we can edit
          COMPREPLY=($(compgen -f -- ${BASH_SOURCES}"/"${COMP_WORDS[COMP_CWORD]}))
          # then engage in some light shell wizardry to prune the path from the reply
          COMPREPLY=("${COMPREPLY[@]##*/}")
          ;;
        *) #literally anything else!
          COMPREPLY=()
          ;;
      esac
      ;;
    *) # too many (or too few?) words to work with
      COMPREPLY=()
      ;;
  esac
}

# then actually enable completion using our function
complete -F _profile_autocomplete profile