# Bash completion for nerd-font-manager
# Install: Add to .bashrc or .bash_profile
#   source /path/to/uni-nerd-font/completions/nerd-font-manager.bash

_nerd_font_manager() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="--cli -c --gui -g --help -h"

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _nerd_font_manager nerd-font-manager
complete -F _nerd_font_manager nerd-font-manager.sh
complete -F _nerd_font_manager ./nerd-font-manager.sh
