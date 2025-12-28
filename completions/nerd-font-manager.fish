# Fish completion for nerd-font-manager
# Install: Copy to ~/.config/fish/completions/ or add completions directory to fish_complete_path

complete -c nerd-font-manager -f
complete -c nerd-font-manager -s c -l cli -d 'Run in CLI mode with fzf (default)'
complete -c nerd-font-manager -s g -l gui -d 'Run in GUI mode with macOS dialogs'
complete -c nerd-font-manager -s h -l help -d 'Show help message'

# Also complete for the .sh version
complete -c nerd-font-manager.sh -f
complete -c nerd-font-manager.sh -s c -l cli -d 'Run in CLI mode with fzf (default)'
complete -c nerd-font-manager.sh -s g -l gui -d 'Run in GUI mode with macOS dialogs'
complete -c nerd-font-manager.sh -s h -l help -d 'Show help message'
