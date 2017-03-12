# Welcome

Thank you for taking the time to check out bash_sources.  This is my attempt to create a functional bash environment without
creating a single monolithic **bash\_profile** file.  I've been in IT 15 years and decided it was time to make a bash\_profile
system that worked well and was easy to extend!

# Installation

To install bash\_sources, simply rename or symlink the **loader.sh** file to your **~/.bash\_profile**:

	ln -s <bash_sources_repo>/loader.sh ~/.bash_profile

Then simply quit and re-launch your terminal and/or `source ~/.bash\_profile`.  Then, you will be able to type `profile`
and see what happens!

# Sources

To add a new source, simply copy or symlink one of the script isn the `sources` directory into the newly created `~/.sources.d` directory:

	ln -s <bash_sources_repo>/sources/00_default.sh ~/sources.d/00_default.sh;

Then, simply type `profile --reload` to load the new profile!

## Loading order

To specify a loading order for source scripts simply prefix them like so:

	00_default.sh -> /Users/jdoe/git/bash_sources/sources/00_default.sh
	10_darwin.sh -> /Users/jdoe/git/bash_sources/sources/10_darwin.sh
	30_git.sh -> /Users/jdoe/git/bash_sources/sources/30_git.sh
	40_fun.sh -> /Users/jdoe/git/bash_sources/sources/40_fun.sh
	90_bash_completion.sh -> /opt/local/etc/profile.d/bash_completion.sh
	90_virtualenvwrapper.sh -> /opt/local/bin/virtualenvwrapper.sh
	99_local.sh

## Other Sources

You can store other sources in your **~/.sources.d** directory.  As long as they do not end with `.sh` they will not
be loaded during shell startup.  For example:

	$ profile info
	### Bash Profile: Loader
	### Author: Jesse Almanrode (jesse@almanrode.com)
	### Version: 1.0
	### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
	### Sources:
	00_default.sh
	10_darwin.sh
	60_git.sh
	90_bash_completion.sh
	91_virtualenvwrapper.sh
	99_local.sh
	special_stuff

In this case, the `special\_stuff` source will not be loaded during shell startup.  You can load it later on by:

	profile load special_stuff


# VIMRC

I've included my simple vimrc file as well.  To install simply:

    ln -s <bash_sources_repo>/vimrc.txt ~/.vimrc
