### Python Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have Python installed

if ! command -v python &>/dev/null; then
    echo "Python is not installed. Not loading source."
    return 1
fi

# Poetry or UV
export PATH="$HOME/.local/bin:$PATH"

# Python version
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $NF}')
export PYTHON_VERSION

# Simple HTTP server (Python 3+ only)
alias simplehttpserver='python -m http.server'

# JSON pretty print
alias json='python -m json.tool'

# Virtual environment helpers
mkvenv() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkvenv <name>"
        return 1
    fi
    python -m venv "$1"
}

activate() {
    local venv="${1:-.venv}"
    if [[ -d "$venv" ]]; then
        source "$venv/bin/activate"
    elif [[ -z "${1:-}" && -d ".venv" ]]; then
        source .venv/bin/activate
    else
        echo "No virtual environment found: $venv"
        return 1
    fi
}
