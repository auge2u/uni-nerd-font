# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A bash utility for managing Nerd Fonts on macOS via Homebrew casks. Provides both CLI (fzf-based) and GUI (osascript-based) interfaces.

## Prerequisites

- macOS
- Homebrew
- fzf (for CLI mode): `brew install fzf`

## Usage

```bash
# CLI mode (default) - requires fzf
./nerd-font-manager.sh
./nerd-font-manager.sh --cli

# GUI mode - uses macOS dialogs
./nerd-font-manager.sh --gui

# Help
./nerd-font-manager.sh --help
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
- **Logging**: All actions logged to `~/.nerd-font-manager.log`
