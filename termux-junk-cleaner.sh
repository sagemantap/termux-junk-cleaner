#!/bin/bash

##   Linux-Junk-Cleaner    :       Junk cleaner (non-root)
##   Modified by           :       ChatGPT (OpenAI) based on Termux script
##   Version               :       1.0.0
##   Based on              :       ArjunCodesmith's Termux-Junk-Cleaner

author="ArjunCodesmith / Modified"
version="v1.0.0"
LOG_FILE="cleanup_log.txt"

# Log date
echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE"
echo -e "\e[1;34mDate: $(date)\e[0m" >> "$LOG_FILE"
echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE"

# Typing effect
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
 ─────────── │  \e[38;5;83m LINUX JΞNK  \e[1;31m │ ───────────
 ─────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ───────────
       ──────│\e[94m [░░░░░▓▓▓▓▓▓▓▓] \e[1;31m│──────
         └─────────┘     └─────────┘\e[0m"
echo -e "              \033[40;38;5;83m Version \033[30;48;5;83m $version \033[0m"
echo -e "         \033[30;48;5;83m    Modified by OpenAI \033[0m"
echo -e " \e[1;34m--------------------------------------------\e[0m"

# Ask user
cleanup_options() {
    read -p $'\n\e[1;35m Clean logs? (y/n): \e[0m' clean_logs
    read -p $'\e[1;35m Clean cache files? (y/n): \e[0m' clean_cache
    read -p $'\e[1;35m Clean apt cache? (y/n): \e[0m' clean_packages
    read -p $'\e[1;35m Remove unused packages? (y/n): \e[0m' clean_unused
    read -p $'\e[1;35m Clean temporary files? (y/n): \e[0m' clean_temp
    read -p $'\e[1;35m Clean backup files (*.bak)? (y/n): \e[0m' clean_bak
}

# Cleanup functions
clean_logs() {
    typing_effect "Cleaning logs..."
    deleted_logs=$(find "$HOME" -type f -name "*.log" -delete -print 2>/dev/null)
    echo "$deleted_logs" >> "$LOG_FILE"
}

clean_cache() {
    typing_effect "Cleaning cache..."
    deleted_cache=$(find "$HOME/.cache" -type f -delete -print 2>/dev/null)
    echo "$deleted_cache" >> "$LOG_FILE"
}

clean_apt_cache() {
    typing_effect "Cleaning apt cache..."
    sudo apt clean 2>/dev/null
    echo "[*] apt clean executed" >> "$LOG_FILE"
}

remove_unused() {
    typing_effect "Removing unused packages..."
    sudo apt autoremove -y 2>/dev/null
    echo "[*] apt autoremove executed" >> "$LOG_FILE"
}

clean_tmp() {
    typing_effect "Cleaning /tmp and ~/tmp..."
    find /tmp -type f -user "$(whoami)" -delete -print 2>/dev/null >> "$LOG_FILE"
    find "$HOME/tmp" -type f -delete -print 2>/dev/null >> "$LOG_FILE"
}

clean_bak() {
    typing_effect "Removing *.bak files..."
    find "$HOME" -type f -name "*.bak" -delete -print 2>/dev/null >> "$LOG_FILE"
}

# DPI firewall evasion notice
firewall_dpi_bypass_notice() {
    echo -e "\n\e[1;36m[~] Passive DPI Firewall Evasion Tips:\e[0m"
    echo -e "\e[1;33m - Use SOCKS5 proxy (ssh -D 1080)\e[0m"
    echo -e "\e[1;33m - Use Tor: torsocks curl https://site\e[0m"
    echo -e "\e[1;33m - Use DoH or DNSCrypt resolver\e[0m"
    echo -e "\e[1;33m - Avoid curl/wget without User-Agent override\e[0m"
}

# Full clean
clean_all() {
    clean_logs
    clean_cache
    clean_apt_cache
    remove_unused
    clean_tmp
    clean_bak
}

# Run by options
check_and_clean() {
    [[ "$clean_logs" =~ ^[yY]$ ]] && clean_logs
    [[ "$clean_cache" =~ ^[yY]$ ]] && clean_cache
    [[ "$clean_packages" =~ ^[yY]$ ]] && clean_apt_cache
    [[ "$clean_unused" =~ ^[yY]$ ]] && remove_unused
    [[ "$clean_temp" =~ ^[yY]$ ]] && clean_tmp
    [[ "$clean_bak" =~ ^[yY]$ ]] && clean_bak
}

# Display help
show_help() {
    echo -e "\nUsage: $0 [options]"
    echo "Options:"
    echo "  -a        Clean all"
    echo "  -c        Clean cache"
    echo "  -p        Clean apt cache"
    echo "  -n        Remove unused packages"
    echo "  -t        Clean temp files"
    echo "  -b        Clean .bak files"
    echo "  -l        Clean log files"
    echo "  -h        Show help"
}

# Main args
args=("$@")
if [[ ${#args[@]} -eq 0 ]]; then
    cleanup_options
    check_and_clean
else
    for arg in "${args[@]}"; do
        case "$arg" in
            -a) clean_all ;;
            -c) clean_cache ;;
            -p) clean_apt_cache ;;
            -n) remove_unused ;;
            -t) clean_tmp ;;
            -b) clean_bak ;;
            -l) clean_logs ;;
            -h|--help) show_help; exit 0 ;;
            *) echo -e "\e[1;31mUnknown option: $arg\e[0m"; show_help; exit 1 ;;
        esac
    done
fi

# Done
echo -e "\n\e[1;32m[✔] Cleanup completed. See $LOG_FILE for details.\e[0m"
firewall_dpi_bypass_notice
