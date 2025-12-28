# Nerd Font Manager

A bash utility for managing [Nerd Fonts](https://www.nerdfonts.com/) on macOS via Homebrew casks. Features both CLI (fzf) and GUI (macOS dialogs) interfaces.

![Demo](demo.gif)

## Prerequisites

- macOS
- [Homebrew](https://brew.sh/)
- [fzf](https://github.com/junegunn/fzf) (for CLI mode): `brew install fzf`

## Installation

```bash
# Clone the repository
git clone https://github.com/auge2u/uni-nerd-font.git
cd uni-nerd-font

# Make executable (already set)
chmod +x nerd-font-manager.sh

# Optional: Add to PATH
ln -s "$(pwd)/nerd-font-manager.sh" /usr/local/bin/nerd-font-manager
```

### Shell Completions

**Zsh** - Add to `~/.zshrc`:
```bash
fpath=(/path/to/uni-nerd-font/completions $fpath)
autoload -Uz compinit && compinit
```

**Bash** - Add to `~/.bashrc` or `~/.bash_profile`:
```bash
source /path/to/uni-nerd-font/completions/nerd-font-manager.bash
```

Then restart your shell or source the config file.

## Usage

```bash
# CLI mode (default) - interactive fzf interface
./nerd-font-manager.sh

# GUI mode - macOS native dialogs
./nerd-font-manager.sh --gui

# Show help
./nerd-font-manager.sh --help
```

## Features

### Actions
- **Install** - Browse and install from 70+ available Nerd Fonts
- **Uninstall** - Remove installed Nerd Fonts
- **Install favorites** - Quick install 8 curated developer fonts
- **Bulk update** - Update all installed Nerd Fonts

### Favorites
Pre-configured popular fonts for developers:
- Fira Code
- JetBrains Mono
- Hack
- Iosevka
- Meslo LG
- Caskaydia Cove (Cascadia Code)
- Roboto Mono
- Sauce Code Pro (Source Code Pro)

### Search & Filter
- **CLI mode**: Real-time filtering as you type (fzf)
- **GUI mode**: Search dialog before font selection

### Bulk Operations
- `[ALL]` option to install/uninstall all fonts at once
- Multi-select support (TAB in CLI, CMD+click in GUI)

### Logging
All actions are logged to `~/.nerd-font-manager.log`

## License

MIT
