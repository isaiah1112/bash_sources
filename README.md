# Welcome

Thank you for taking the time to check out bash_sources.  This is my attempt to create a modular bash environment with a minimalistic
**bashrc** file.  Since I've worked in IT for over 20 years I figured it was time I put some of my knowledge to good use.

# Installation

To get started, run:

    ./install bashrc

This will:
- Install bash_profile and bashrc as symlinks to your home directory
- Create `~/.bash_sources.d` directory
- Automatically install all available bash source files
- Back up any existing files with a `.pre-bash_sources` suffix

Then simply quit and re-launch your terminal.

For detailed installation options, run:

    ./install -h

# Sources

All available sources are automatically installed when you run `./install bashrc`. To load a newly added source file later, simply run:

    profile reload

(Or restart your terminal)

## Loading Order

Source files are loaded in alphabetical order based on their numeric prefix:

    00_default.sh -> first
    10_darwin.sh
    10_linux.sh
    ...
    90_fun.sh -> last

Additional sources in `~/.bash_sources.d` are loaded in the same order.

## Adding Custom Sources

You can add your own bash scripts to `~/.bash_sources.d`. Any file ending in `.sh` will be automatically sourced, loaded in alphabetical order.

# Installing Other Configurations

## VIMRC

    ./install vimrc

## SSH Config

    ./install sshcfg

# Upgrading

Simply run the install commands again. The installer will:
- Validate all bash files for syntax errors
- Back up existing files (if not already backed up)
- Update symlinks to the latest versions
- Warn if backups already exist

To force reinstall even if already installed:

    FORCE_INSTALL=1 ./install bashrc