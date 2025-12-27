# VHS Demo Tape for Nerd Font Manager
Output demo.gif

Set Shell "bash"
Set FontSize 14
Set Width 800
Set Height 500
Set Theme "Catppuccin Mocha"

Type "./nerd-font-manager.sh --help"
Sleep 500ms
Enter
Sleep 2s

Type "./nerd-font-manager.sh"
Sleep 500ms
Enter
Sleep 2s

# Navigate in fzf - select Install
Type "i"
Sleep 500ms
Enter
Sleep 3s

# Filter for "fira"
Type "fira"
Sleep 1s

# Exit with Escape
Escape
Sleep 1s
Escape
Sleep 1s

Type "echo 'Demo complete!'"
Enter
Sleep 2s
