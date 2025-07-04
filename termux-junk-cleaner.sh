#!/bin/bash

# Termux Junk Cleaner - Anti Dismiss Edition
# Author  : ArjunCodesmith (Enhanced by ChatGPT)
# Version : v0.2.1

author="ArjunCodesmith"
version="v0.2.1 (Anti-Dismiss Edition)"
LOG_DIR="$HOME/.termux-junk-cleaner"
LOG_FILE="$LOG_DIR/cleanup_log.txt"

# 🚫 Prevent termination when Termux is backgrounded
termux-wake-lock

# Optional proxy (uncomment if needed)
# export http_proxy="http://127.0.0.1:8080"
# export https_proxy="http://127.0.0.1:8080"

# Ensure all needed directories exist
mkdir -p "$HOME/.cache" "$HOME/tmp" "$LOG_DIR"

# Log date header
{
  echo -e "\n\e[1;34m-------------------------------\e[0m"
  echo -e "\e[1;34mDate: $(date)\e[0m"
  echo -e "\e[1;34m-------------------------------\e[0m"
} >> "$LOG_FILE"

# Simulate typing effect
typing_effect() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo
}

# Banner
echo -e "\e[1;31m
         ┌─────────┐     ┌─────────┐
       ──────│\e[94m [▓▓▓▓▓▓▓▓░░░░░] \e[1;31m│──────
 ─────────── │  \e[38;5;83m TΞRMUX JΞNK \e[1;31m  │ ───────────
 ─────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ───────────
       ──────│\e[94m [░░░░░▓▓▓▓▓▓▓▓] \e[1;31m│──────
         └─────────┘     └─────────┘\e[0m"
echo -e "         \033[30;48;5;83m Version: $version | Author: $author \033[0m"
echo -e " \e[1;34m--------------------------------------------\e[0m"

# Prompt options if no args
cleanup_options() {
    read -p $'\n\e[1;35mClean logs? (y/n): \e[0m' clean_logs
    read -p $'\e[1;35mClean cache? (y/n): \e[0m' clean_cache
    read -p $'\e[1;35mClean cached packages? (y/n): \e[0m' clean_packages
    read -p $'\e[1;35mRemove unused packages? (y/n): \e[0m' clean_unused_packages
    read -p $'\e[1;35mClean temp files? (y/n): \e[0m' clean_temp
    read -p $'\e[1;35mClean backup files? (y/n): \e[0m' clean_temp_backup
}

clean_cache() {
    typing_effect $'\n\e[1;32mCleaning cache...\e[0m'
    find "$HOME/.cache" -type f -delete -print >> "$LOG_FILE" 2>/dev/null
    find "$HOME/.termux/cache" -type f -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_cached_packages() {
    typing_effect $'\n\e[1;32mCleaning apt cache...\e[0m'
    apt-get clean >> "$LOG_FILE" 2>&1
}

remove_unused_packages() {
    typing_effect $'\n\e[1;32mRemoving unused packages...\e[0m'
    apt autoremove -y >> "$LOG_FILE" 2>&1
}

clean_temp_files() {
    typing_effect $'\n\e[1;32mCleaning temp files...\e[0m'
    find "$HOME/tmp" -type f -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_temp_backup_files() {
    typing_effect $'\n\e[1;32mCleaning backup (*.bak)...\e[0m'
    find "$HOME" -type f -name "*.bak" -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_unnecessary_logs() {
    typing_effect $'\n\e[1;32mCleaning log (*.log)...\e[0m'
    echo -e "\n\e[1;31mOld cleanup logs deleted.\e[0m" > "$LOG_FILE"
    find "$HOME" -type f -name "*.log" -delete -print >> "$LOG_FILE" 2>/dev/null
}

success_msg() {
    echo -e "\n✅ \e[40;38;5;83mCleanup completed. Log: $LOG_FILE \e[0m\n"
}

clean_all() {
    clean_unnecessary_logs
    clean_cache
    clean_cached_packages
    remove_unused_packages
    clean_temp_files
    clean_temp_backup_files
}

check_and_clean() {
    [[ "$clean_logs" =~ ^[Yy]$ ]] && clean_unnecessary_logs || echo -e "\n⏩ Skipped log cleanup." >> "$LOG_FILE"
    [[ "$clean_cache" =~ ^[Yy]$ ]] && clean_cache || echo -e "\n⏩ Skipped cache cleanup." >> "$LOG_FILE"
    [[ "$clean_packages" =~ ^[Yy]$ ]] && clean_cached_packages || echo -e "\n⏩ Skipped package cache." >> "$LOG_FILE"
    [[ "$clean_unused_packages" =~ ^[Yy]$ ]] && remove_unused_packages || echo -e "\n⏩ Skipped unused package removal." >> "$LOG_FILE"
    [[ "$clean_temp" =~ ^[Yy]$ ]] && clean_temp_files || echo -e "\n⏩ Skipped temp cleanup." >> "$LOG_FILE"
    [[ "$clean_temp_backup" =~ ^[Yy]$ ]] && clean_temp_backup_files || echo -e "\n⏩ Skipped .bak cleanup." >> "$LOG_FILE"
}

display_help() {
    echo -e "\n📘 Usage: clean [options]"
    echo -e "  -a        Clean all"
    echo -e "  -c        Clean cache"
    echo -e "  -p        Clean cached packages"
    echo -e "  -n        Remove unused packages"
    echo -e "  -t        Clean temp files"
    echo -e "  -b        Clean .bak files"
    echo -e "  -l        Clean log files"
    echo -e "  -h        Help"
    echo -e "Example: clean -c -t\n"
}

# --- Handle Args ---
if [ "$#" -eq 0 ]; then
    cleanup_options
    check_and_clean
    success_msg
    termux-wake-unlock
    exit 0
fi

for arg in "$@"; do
    case "$arg" in
        -a) clean_all ;;
        -c) clean_cache ;;
        -p) clean_cached_packages ;;
        -n) remove_unused_packages ;;
        -t) clean_temp_files ;;
        -b) clean_temp_backup_files ;;
        -l) clean_unnecessary_logs ;;
        -h|--help) display_help; termux-wake-unlock; exit 0 ;;
        *) echo -e "\n❌ Invalid option: $arg\n"; display_help; termux-wake-unlock; exit 1 ;;
    esac
done

success_msg

# ✅ Release wakelock after done
termux-wake-unlock
