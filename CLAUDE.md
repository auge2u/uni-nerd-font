# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A bash utility for managing Nerd Fonts on macOS via Homebrew casks. Provides both CLI (fzf-based) and GUI (osascript-based) interfaces.

**Current version**: 1.0.2

## Installation

### Homebrew (Recommended)
```bash
brew tap auge2u/uni-nerd-font https://github.com/auge2u/uni-nerd-font
brew install nerd-font-manager
```

### Manual
```bash
git clone https://github.com/auge2u/uni-nerd-font.git
cd uni-nerd-font
chmod +x nerd-font-manager.sh
./nerd-font-manager.sh
```

## Usage

```bash
# CLI mode (default) - requires fzf
nerd-font-manager
nerd-font-manager --cli

# GUI mode - uses macOS dialogs
nerd-font-manager --gui

# Help
nerd-font-manager --help
```

## Project Structure

```
uni-nerd-font/
├── nerd-font-manager.sh      # Main script (~350 lines)
├── Formula/
│   └── nerd-font-manager.rb  # Homebrew formula
├── completions/
│   ├── _nerd-font-manager    # Zsh completions
│   ├── nerd-font-manager.bash # Bash completions
│   └── nerd-font-manager.fish # Fish completions
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI
├── README.md
├── CHANGELOG.md
├── LICENSE                   # MIT
├── demo.gif                  # Demo animation
└── demo.tape                 # VHS recording script
```

## Architecture

Single bash script (`nerd-font-manager.sh`) with these sections:
- **Config**: Log file path and favorites array (8 curated fonts)
- **Helpers**: Logging, Homebrew tap management, font listing
- **Core actions**: Install/uninstall/update fonts via Homebrew casks
- **CLI mode**: Interactive fzf-based selection with real-time filtering
- **GUI mode**: macOS osascript dialog-based selection with search dialog
- **Main**: Command-line argument parsing

Font cask naming convention: `font-{name}-nerd-font` (e.g., `font-fira-code-nerd-font`)

## Features

- **Search/Filter**: CLI mode has real-time fzf filtering; GUI mode prompts for search term
- **Select All**: `[ALL]` option at top of font lists for bulk operations
- **Multi-select**: TAB to select multiple fonts in CLI mode; CMD+click in GUI mode
- **Favorites**: 8 curated developer fonts (Fira Code, JetBrains Mono, Hack, Iosevka, Meslo LG, Caskaydia Cove, Roboto Mono, Sauce Code Pro)
- **Logging**: All actions logged to `~/.nerd-font-manager.log`

## Development

### Testing
```bash
# Syntax check
bash -n nerd-font-manager.sh

# ShellCheck linting
shellcheck nerd-font-manager.sh

# Test help flag
./nerd-font-manager.sh --help
```

### CI Workflow
GitHub Actions runs on push/PR to main:
- Test Homebrew formula installation on macOS
- Test script directly with fzf
- Run ShellCheck for linting

### Creating a Release
1. Update CHANGELOG.md
2. Create and push tag: `git tag -a v1.x.x -m "message" && git push origin v1.x.x`
3. Create GitHub release: `gh release create v1.x.x --title "title" --notes "notes"`
4. Get new SHA256: `curl -sL <tarball-url> | shasum -a 256`
5. Update Formula/nerd-font-manager.rb with new version, URL, and SHA256
6. Commit and push formula update
