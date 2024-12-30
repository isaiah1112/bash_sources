# Welcome

Thank you for taking the time to check out bash_sources.  This is my attempt to create a modular bash environment with a minimalistic
**bashrc** file.  Since I've worked in IT for over 20 years I figured it was time I put some of my knowledge to good use.

# Installation

To get started, run the following:

	./install.sh bashrc

Then simply quit and re-launch your terminal.

# Sources

To add a new source, simply run the following:

	./install.sh <profile>

Then, simply type `profile reload` to load the new profile!

## Loading order

To specify a loading order for source scripts simply prefix with integers. Below is an example of how to load profiles
in a specific order:

	00_default.sh -> /Users/jdoe/git/bash_sources/sources/00_default.sh
	10_darwin.sh -> /Users/jdoe/git/bash_sources/sources/10_darwin.sh
	30_git.sh -> /Users/jdoe/git/bash_sources/sources/30_git.sh
	40_fun.sh -> /Users/jdoe/git/bash_sources/sources/40_fun.sh
	90_bash_completion.sh -> /opt/local/etc/profile.d/bash_completion.sh
	90_virtualenvwrapper.sh -> /opt/local/bin/virtualenvwrapper.sh
	99_local.sh

## Other Sources

You can store other sources in your **~/.bash_sources.d** directory.  As long as they are bash scripts (ending with `.sh`)
they will be loaded as a source by `.bashrc`!


# VIMRC or SSH Config

I've also included my `vimrc` and `ssh` config files. To install them simply:

	./install.sh vimrc
	./install.sh sshcfg

# Upgrading from a previous version

When upgrading from a pre-v2.X version of bash_sources, perform the following:

	unlink ~/.bash_profile;
	rm ~/.sources.d; # Optional. If you have non-linked sources in here move them to the new ~/.bash_sources.d directory before deleting this one.