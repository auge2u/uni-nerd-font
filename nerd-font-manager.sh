#!/usr/bin/env bash

# =============================
# Config
# =============================

LOG_FILE="$HOME/.nerd-font-manager.log"

# Updated favorites (8 fonts)
FAVORITES=(
  "fira-code"
  "jetbrains-mono"
  "hack"
  "iosevka"
  "meslo-lg"
  "caskaydia-cove"
  "roboto-mono"
  "sauce-code-pro"
)

# =============================
# Helpers
# =============================

log_event() {
  local action="$1"
  local font="$2"
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $action | $font" >> "$LOG_FILE"
}

ensure_fonts_tap() {
  if ! brew tap | grep -q "^homebrew/cask-fonts$"; then
    echo "Adding Homebrew tap: homebrew/cask-fonts"
    brew tap homebrew/cask-fonts
  fi
}

get_available_fonts() {
  ensure_fonts_tap
  brew search --casks nerd-font | grep "font-.*-nerd-font"
}

get_installed_fonts() {
  brew list --cask | grep "font-.*-nerd-font"
}

get_installed_nerd_casks() {
  brew list --cask | grep "font-.*-nerd-font"
}

# =============================
# Core actions
# =============================

install_fonts_by_middle_names() {
  local names=("$@")
  for font in "${names[@]}"; do
    local cask="font-${font}-nerd-font"
    echo "Installing: $cask"
    if brew install --cask "$cask"; then
      log_event "INSTALL" "$cask"
    else
      log_event "INSTALL_FAILED" "$cask"
    fi
  done
}

uninstall_fonts_by_middle_names() {
  local names=("$@")
  for font in "${names[@]}"; do
    local cask="font-${font}-nerd-font"
    echo "Uninstalling: $cask"
    if brew uninstall --cask "$cask"; then
      log_event "UNINSTALL" "$cask"
    else
      log_event "UNINSTALL_FAILED" "$cask"
    fi
  done
}

bulk_update_fonts() {
  local casks
  casks=$(get_installed_nerd_casks)
  if [ -z "$casks" ]; then
    echo "No Nerd Fonts installed to update."
    return
  fi

  echo "Updating all installed Nerd Fonts..."
  echo "$casks" | while read -r cask; do
    echo "Upgrading: $cask"
    if brew upgrade --cask "$cask"; then
      log_event "UPGRADE" "$cask"
    else
      log_event "UPGRADE_FAILED" "$cask"
    fi
  done
  echo "Bulk update complete."
}

# =============================
# CLI mode (fzf)
# =============================

cli_mode() {
  if ! command -v fzf &> /dev/null; then
    echo "fzf is required for CLI mode. Install it with: brew install fzf"
    exit 1
  fi

  local ACTION
  ACTION=$(printf "Install\nUninstall\nInstall favorites\nBulk update" | fzf --prompt="Choose action > ")

  if [ -z "$ACTION" ]; then
    echo "No action selected."
    exit 0
  fi

  case "$ACTION" in
    "Install")
      local FONTS
      FONTS=$(get_available_fonts | sed 's/font-//; s/-nerd-font//')

      if [ -z "$FONTS" ]; then
        echo "No Nerd Fonts found in Homebrew."
        exit 0
      fi

      # Add [ALL] option and enable search with header hint
      local SELECTED
      SELECTED=$(echo -e "[ALL] Install all fonts\n$FONTS" | fzf --multi --prompt="Install (type to filter) > " --header="Select fonts (TAB to multi-select, ENTER to confirm)")

      if [ -z "$SELECTED" ]; then
        echo "Nothing selected."
        exit 0
      fi

      # Check if ALL was selected
      if echo "$SELECTED" | grep -q "^\[ALL\]"; then
        echo "Installing ALL available Nerd Fonts..."
        mapfile -t names <<< "$FONTS"
      else
        mapfile -t names <<< "$SELECTED"
      fi
      install_fonts_by_middle_names "${names[@]}"
      ;;

    "Uninstall")
      local FONTS
      FONTS=$(get_installed_fonts | sed 's/font-//; s/-nerd-font//')

      if [ -z "$FONTS" ]; then
        echo "No Nerd Fonts installed."
        exit 0
      fi

      # Add [ALL] option and enable search with header hint
      local SELECTED
      SELECTED=$(echo -e "[ALL] Uninstall all fonts\n$FONTS" | fzf --multi --prompt="Uninstall (type to filter) > " --header="Select fonts (TAB to multi-select, ENTER to confirm)")

      if [ -z "$SELECTED" ]; then
        echo "Nothing selected."
        exit 0
      fi

      # Check if ALL was selected
      if echo "$SELECTED" | grep -q "^\[ALL\]"; then
        echo "Uninstalling ALL installed Nerd Fonts..."
        mapfile -t names <<< "$FONTS"
      else
        mapfile -t names <<< "$SELECTED"
      fi
      uninstall_fonts_by_middle_names "${names[@]}"
      ;;

    "Install favorites")
      echo "Installing favorite fonts: ${FAVORITES[*]}"
      install_fonts_by_middle_names "${FAVORITES[@]}"
      ;;

    "Bulk update")
      bulk_update_fonts
      ;;

    *)
      echo "Unknown action."
      ;;
  esac

  echo "Done!"
}

# =============================
# GUI mode (osascript)
# =============================

gui_choose_action() {
  osascript <<EOF
choose from list {"Install", "Uninstall", "Install favorites", "Bulk update"} with title "Nerd Font Manager" with prompt "Choose an action:"
EOF
}

gui_mode() {
  local ACTION
  ACTION=$(gui_choose_action)

  if [[ "$ACTION" == "false" ]]; then
    exit 0
  fi

  case "$ACTION" in
    "Install")
      local FONTS
      FONTS=$(get_available_fonts | sed 's/font-//; s/-nerd-font//')

      if [ -z "$FONTS" ]; then
        osascript -e 'display alert "No Nerd Fonts found in Homebrew." as warning'
        exit 0
      fi

      # Optional search filter
      local SEARCH
      if ! SEARCH=$(osascript <<EOF
display dialog "Enter search term (leave empty for all fonts):" default answer "" with title "Filter Fonts" buttons {"Cancel", "Search"} default button "Search"
text returned of result
EOF
); then
        exit 0
      fi

      # Filter fonts if search term provided
      local FILTERED_FONTS
      if [ -n "$SEARCH" ]; then
        FILTERED_FONTS=$(echo "$FONTS" | grep -i "$SEARCH")
        if [ -z "$FILTERED_FONTS" ]; then
          osascript -e "display alert \"No fonts matching '$SEARCH' found.\" as warning"
          exit 0
        fi
      else
        FILTERED_FONTS="$FONTS"
      fi

      # Add [ALL] option at the beginning
      local FONT_LIST
      FONT_LIST=$(echo "$FILTERED_FONTS" | tr '\n' ',' | sed 's/,$//' | sed 's/,/", "/g')

      local SELECTED
      SELECTED=$(osascript <<EOF
choose from list {"[ALL]", "$FONT_LIST"} with title "Install Nerd Fonts" with prompt "Select fonts to install:" with multiple selections allowed
EOF
)

      if [[ "$SELECTED" == "false" ]]; then
        exit 0
      fi

      # Check if ALL was selected
      if [[ "$SELECTED" == *"[ALL]"* ]]; then
        echo "Installing ALL filtered Nerd Fonts..."
        mapfile -t names <<< "$FILTERED_FONTS"
      else
        IFS=', ' read -ra names <<< "$SELECTED"
      fi
      install_fonts_by_middle_names "${names[@]}"
      ;;

    "Uninstall")
      local FONTS
      FONTS=$(get_installed_fonts | sed 's/font-//; s/-nerd-font//')

      if [ -z "$FONTS" ]; then
        osascript -e 'display alert "No Nerd Fonts installed." as warning'
        exit 0
      fi

      # Optional search filter
      local SEARCH
      if ! SEARCH=$(osascript <<EOF
display dialog "Enter search term (leave empty for all fonts):" default answer "" with title "Filter Fonts" buttons {"Cancel", "Search"} default button "Search"
text returned of result
EOF
); then
        exit 0
      fi

      # Filter fonts if search term provided
      local FILTERED_FONTS
      if [ -n "$SEARCH" ]; then
        FILTERED_FONTS=$(echo "$FONTS" | grep -i "$SEARCH")
        if [ -z "$FILTERED_FONTS" ]; then
          osascript -e "display alert \"No fonts matching '$SEARCH' found.\" as warning"
          exit 0
        fi
      else
        FILTERED_FONTS="$FONTS"
      fi

      # Add [ALL] option at the beginning
      local FONT_LIST
      FONT_LIST=$(echo "$FILTERED_FONTS" | tr '\n' ',' | sed 's/,$//' | sed 's/,/", "/g')

      local SELECTED
      SELECTED=$(osascript <<EOF
choose from list {"[ALL]", "$FONT_LIST"} with title "Uninstall Nerd Fonts" with prompt "Select fonts to uninstall:" with multiple selections allowed
EOF
)

      if [[ "$SELECTED" == "false" ]]; then
        exit 0
      fi

      # Check if ALL was selected
      if [[ "$SELECTED" == *"[ALL]"* ]]; then
        echo "Uninstalling ALL filtered Nerd Fonts..."
        mapfile -t names <<< "$FILTERED_FONTS"
      else
        IFS=', ' read -ra names <<< "$SELECTED"
      fi
      uninstall_fonts_by_middle_names "${names[@]}"
      ;;

    "Install favorites")
      echo "Installing favorite fonts: ${FAVORITES[*]}"
      install_fonts_by_middle_names "${FAVORITES[@]}"
      ;;

    "Bulk update")
      bulk_update_fonts
      ;;

    *)
      echo "Unknown action."
      ;;
  esac

  osascript -e 'display alert "Done!" as informational'
}

# =============================
# Main entry point
# =============================

main() {
  case "${1:-}" in
    --gui|-g)
      gui_mode
      ;;
    --cli|-c|"")
      cli_mode
      ;;
    --help|-h)
      echo "Usage: $0 [--cli|-c] [--gui|-g] [--help|-h]"
      echo "  --cli, -c   Run in CLI mode with fzf (default)"
      echo "  --gui, -g   Run in GUI mode with macOS dialogs"
      echo "  --help, -h  Show this help message"
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information."
      exit 1
      ;;
  esac
}

main "$@"
