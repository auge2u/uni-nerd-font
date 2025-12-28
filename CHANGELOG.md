# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-12-28

### Fixed
- ShellCheck warnings (proper variable quoting, direct exit code checks)

### Added
- GitHub Actions CI workflow (formula testing, script testing, ShellCheck)
- CI badge to README

### Changed
- Homebrew formula now uses release tags with SHA256 verification

## [1.0.0] - 2025-12-28

### Added
- Initial release
- CLI mode with fzf for interactive font selection
- GUI mode with native macOS dialogs
- Install/uninstall individual or multiple fonts
- Quick install of 8 curated developer favorites (Fira Code, JetBrains Mono, Hack, Iosevka, Meslo LG, Caskaydia Cove, Roboto Mono, Sauce Code Pro)
- Bulk update all installed Nerd Fonts
- Search/filter functionality in both modes
- `[ALL]` option for bulk operations
- Zsh and Bash shell completions
- Homebrew formula for easy installation
- Logging to `~/.nerd-font-manager.log`

[1.0.1]: https://github.com/auge2u/uni-nerd-font/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/auge2u/uni-nerd-font/releases/tag/v1.0.0
