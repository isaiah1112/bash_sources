### MacPorts (https://www.macports.org/)
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)

# Check if MacPorts is installed
if [ ! -f /opt/local/bin/port ]; then
    echo "MacPorts not installed. Skipping source.";
    return 1;
fi

# Update PATH to include MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH";
# Use GNU toosl
# export PATH="/opt/local/libexec/gnubin/:$PATH";

# Add aliases for MacPorts
alias portupdate="sudo port selfupdate && sudo port upgrade outdated";
alias portclean="sudo port clean -f --all installed && sudo port -f uninstall inactive && sudo port uninstall leaves";

# Setup VirtualENVWrapper
if [ -f /opt/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON='/opt/local/bin/python'
    export VIRTUALENVWRAPPER_VIRTUALENV='/opt/local/bin/virtualenv'
    export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/opt/local/bin/virtualenv-clone'
    source /opt/local/bin/virtualenvwrapper.sh
fi

# Bash Completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  source /opt/local/etc/profile.d/bash_completion.sh
fi
