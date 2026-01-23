### Python Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have Python installed

if [ -z "$(which python 2>/dev/null)" ]; then
    echo "python is not installed. Not loading source.";
    return 1;
fi

# Poetry or UV
export PATH="/Users/jesse/.local/bin:$PATH";
# Env
export PYTHON_VERSION=$(python --version 2>&1 | awk '{print $NF}');

if [[ $PYTHON_VERSION == 3.* ]]; then
    alias simplehttpserver='python -m http.server';
else
    alias simplehttpserver='python -m SimpleHTTPServer';
fi
alias json='python -m json.tool';
