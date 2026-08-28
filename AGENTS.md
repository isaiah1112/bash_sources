# AGENTS.md

## Repository Overview

This repository contains a modular Bash environment for macOS and Linux, plus
optional Vim and SSH configuration. The main pieces are:

- `install`: installs components as symlinks under `$HOME` and creates backups
  with the `.pre-bash_sources` suffix.
- `bash_sources/bash_profile.sh`: loads the user's Bash configuration.
- `bash_sources/bashrc.sh`: sources `~/.bash_sources.d/*.sh` in alphabetical
  order and provides the `profile` helper.
- `bash_sources/*.sh`: default, platform-specific, and tool-specific modules.
- `vimrc` and `ssh/config`: optional editor and SSH configuration.

## Making Changes

- Preserve the numbered filename convention when adding a Bash source; loading
  order is alphabetical.
- Keep platform- or tool-specific behavior in its matching module and guard it
  when the dependency is optional or unavailable.
- Use Bash syntax already present in the repository, including `[[ ]]`, quoted
  expansions, functions, and `local` variables.
- Avoid destructive changes to user configuration. Remember that installation
  can replace files with symlinks and create `.pre-bash_sources` backups.
- Treat `ssh/config` and modules that invoke tools or change system permissions
  as user-facing configuration with potentially significant side effects.

## Validation

There is no test suite, formatter, package manifest, or CI configuration. Before
submitting a change, check all shell scripts for syntax errors:

```bash
bash -n install bash_sources/*.sh
```

For installer-related changes, inspect the help output without modifying the
home directory:

```bash
./install --help
```

## Installation and Manual Checks

The supported entry points are:

```bash
./install bashrc
./install <source_file>
./install vimrc
./install sshcfg
FORCE_INSTALL=1 ./install bashrc
```

After adding or editing an installed source, run `profile reload` in an
interactive Bash session or restart the terminal. Do not run installation
commands casually during validation because they modify files under `$HOME`.