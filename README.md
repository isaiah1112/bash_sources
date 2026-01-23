# Welcome

Thank you for taking the time to check out bash_sources.  This is my attempt to create a modular bash environment with a minimalistic
**bashrc** file.  Since I've worked in IT for over 20 years I figured it was time I put some of my knowledge to good use.

# Installation

To get started, run:

    ./install bashrc

This will:
- Install bash_profile and bashrc as symlinks to your home directory
- Create `~/.bash_sources.d` directory
- Automatically install `00_default.sh`  bash source file
- Back up any existing files with a `.pre-bash_sources` suffix

Then simply quit and re-launch your terminal.

For detailed installation options, run:

    ./install -h

# Sources

The base `00_default.sh` source is installed automatically. To add additional sources, run:

    ./install <source_file>

For example:

    ./install 10_darwin.sh
    ./install 60_docker.sh

Then, simply run `profile reload` to load the new source (or restart your terminal).

## Loading order

Source files are loaded in alphabetical order. Files in `~/.bash_sources.d` are sourced in order:

    00_default.sh (base, installed by default)
    10_darwin.sh
    10_linux.sh
    40_macports.sh
    60_docker.sh
    60_ffmpeg.sh
    ...
    90_fun.sh

## Adding Custom Sources

You can add your own bash scripts to `~/.bash_sources.d`. Any file ending in `.sh` will be automatically sourced, loaded in alphabetical order.

# VIMRC or SSH Config

I've also included `vimrc` and `ssh` config files. To install them:

    ./install vimrc
    ./install sshcfg

# Upgrading

Simply re-run the install commands. The installer will:
- Validate all bash files for syntax errors
- Back up existing files (if not already backed up) with the `.pre-bash_sources` suffix
- Update symlinks to the latest versions
- Warn if backups already exist

To force reinstall even if already installed:

    FORCE_INSTALL=1 ./install bashrc

## Upgrading from pre-v2.X versions

If upgrading from an older version:

    unlink ~/.bash_profile
    rm ~/.sources.d  # Optional. Move any custom sources to ~/.bash_sources.d first