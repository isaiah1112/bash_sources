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
    *) # too many (or too few?) words to work with
      COMPREPLY=()
      ;;
  esac
}

# then actually enable completion using our function
complete -F _profile_autocomplete profile