#!/bin/bash

#  Termux Junk Cleaner (No Root, with Stats)
#  Author: ArjunCodesmith (modded by ChatGPT)
#  Version: 0.3.0-no-root-stats

author="ArjunCodesmith"
version="v0.3.0-no-root-stats"
LOG_DIR="$HOME/.termux-junk-cleaner"
LOG_FILE="$LOG_DIR/cleanup_log.txt"
mkdir -p "$LOG_DIR"

# Print header
echo -e "\n📅 Date: $(date)\n" >> "$LOG_FILE"

typing_effect() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.01
    done
    echo
}

print_banner() {
    clear
    echo -e "\e[1;31m
         ┌─────────┐     ┌─────────┐
       ──────│\e[94m [▓▓▓▓▓▓▓▓░░░░░] \e[1;31m│──────
 ─────────── │  \e[38;5;83m TΞRMUX JΞNK \e[1;31m  │ ───────────
 ─────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ───────────
       ──────│\e[94m [░░░░░▓▓▓▓▓▓▓▓] \e[1;31m│──────
         └─────────┘     └─────────┘\e[0m"
    echo -e "         \033[30;48;5;83m Version: $version | Author: $author \033[0m"
    echo -e " \e[1;34m--------------------------------------------\e[0m"
}

count_and_clean() {
    local path="$1"
    local name="$2"
    local pattern="$3"
    
    if [ -d "$path" ] || [[ "$path" == "$HOME" ]]; then
        local count=$(find "$path" -type f -name "$pattern" | wc -l)
        local size=$(find "$path" -type f -name "$pattern" -exec du -cb {} + 2>/dev/null | grep total | awk '{print $1}')
        local size_hr=$(numfmt --to=iec --suffix=B $size 2>/dev/null || echo "${size}B")

        typing_effect "🧹 $name: Found $count files, $size_hr to remove."
        find "$path" -type f -name "$pattern" -delete -print >> "$LOG_FILE" 2>/dev/null
    else
        echo -e "⚠️  $name directory not found: $path"
    fi
}

clean_cache() {
    count_and_clean "$HOME/.cache" "Cache files" "*"
}

clean_temp_files() {
    count_and_clean "$HOME/tmp" "Temporary files" "*"
}

clean_backup_files() {
    count_and_clean "$HOME" "Backup files (*.bak)" "*.bak"
}

clean_log_files() {
    count_and_clean "$HOME" "Log files (*.log)" "*.log"
}

success_msg() {
    echo -e "\n✅ \e[1;32mCleanup completed!\e[0m"
    echo -e "📝 Log: \e[1;34m$LOG_FILE\e[0m"
}

display_help() {
    echo -e "\n📘 \e[1;36mTermux Junk Cleaner Help:\e[0m"
    echo -e "  clean [options]"
    echo -e "  Options:"
    echo -e "    -a        Clean all"
    echo -e "    -c        Clean cache"
    echo -e "    -t        Clean temporary files"
    echo -e "    -b        Clean backup (*.bak)"
    echo -e "    -l        Clean logs (*.log)"
    echo -e "    -h        Show help"
    echo -e "\nExample:"
    echo -e "  clean -c -b"
}

# Main
print_banner

if [[ "$#" -eq 0 ]]; then
    read -p $'\nClean cache files? (y/n): ' ch1
    read -p $'Clean temp files? (y/n): ' ch2
    read -p $'Clean backup files (*.bak)? (y/n): ' ch3
    read -p $'Clean log files (*.log)? (y/n): ' ch4
    [[ "$ch1" =~ ^[Yy]$ ]] && clean_cache
    [[ "$ch2" =~ ^[Yy]$ ]] && clean_temp_files
    [[ "$ch3" =~ ^[Yy]$ ]] && clean_backup_files
    [[ "$ch4" =~ ^[Yy]$ ]] && clean_log_files
    success_msg
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -a) clean_cache; clean_temp_files; clean_backup_files; clean_log_files ;;
        -c) clean_cache ;;
        -t) clean_temp_files ;;
        -b) clean_backup_files ;;
        -l) clean_log_files ;;
        -h|--help) display_help; exit 0 ;;
        *) echo -e "\n❌ Invalid option: $1\nUse -h for help.\n"; exit 1 ;;
    esac
    shift
done

success_msg
