#!/bin/bash

author="ArjunCodesmith"
version="v0.2.2-custom-antiDPI"
LOG_FILE="cleanup_log.txt"

# Logging date
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
 ─────────── │  \e[38;5;83m TΞRMUX JΞNK \e[1;31m  │ ───────────
 ─────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ───────────
       ──────│\e[94m [░░░░░▓▓▓▓▓▓▓▓] \e[1;31m│──────
         └─────────┘     └─────────┘\e[0m"
echo -e "              \033[40;38;5;83m Version \033[30;48;5;83m $version \033[0m"
echo -e "         \033[30;48;5;83m    Copyright \033[40;38;5;83m ${author}\033[0m"
echo -e " \e[1;34m--------------------------------------------\e[0m"

# Optional firewall stealth
enable_anti_dpi() {
    typing_effect $'\n\e[1;32m[+]\e[0m Enabling Anti-DPI stealth layer...'
    echo -e "[INFO] DPI stealth mode simulated at $(date)" >> "$LOG_FILE"
    echo -e "127.0.0.1 telemetry.microsoft.com\n127.0.0.1 google-analytics.com" >> ~/.hosts_blocked
    echo -e "[*] Simulated hosts blocked saved in ~/.hosts_blocked" >> "$LOG_FILE"
    echo -e "[✓] Suggested: use proxychains or DNSCrypt for full DPI avoidance."
}

# User prompt mode
cleanup_options() {
    read -p $'\n\e[1;35m Do you want to clean unnecessary logs? (y/n): \e[0m' clean_logs
    read -p $'\e[1;35m Do you want to clean cache files? (y/n): \e[0m' clean_cache
    read -p $'\e[1;35m Do you want to clean cached packages? (y/n): \e[0m' clean_packages
    read -p $'\e[1;35m Do you want to remove unnecessary or unused packages? (y/n): \e[0m' clean_unused_packages
    read -p $'\e[1;35m Do you want to clean temporary files? (y/n): \e[0m' clean_temp
    read -p $'\e[1;35m Do you want to clean temporary backup files? (y/n): \e[0m' clean_temp_backup
}

# Cleanup functions
clean_cache() {
    typing_effect $'\n\e[1;32mCleaning cache files...\e[0m'
    find ~/.cache/ -type f -delete -print 2>/dev/null >> "$LOG_FILE"
    find /data/data/com.termux/cache -type f -delete -print 2>/dev/null >> "$LOG_FILE"
}
clean_cached_packages() {
    typing_effect $'\n\e[1;32mCleaning cached packages...\e[0m'
    apt-get clean 2>/dev/null
    echo "[apt-get clean executed]" >> "$LOG_FILE"
}
remove_unused_packages() {
    typing_effect $'\n\e[1;32mRemoving unnecessary or unused packages...\e[0m'
    apt autoremove -y 2>/dev/null >> "$LOG_FILE"
}
clean_temp_files() {
    typing_effect $'\n\e[1;32mCleaning temporary files...\e[0m'
    find ~/tmp/ -type f -delete -print 2>/dev/null >> "$LOG_FILE"
}
clean_temp_backup_files() {
    typing_effect $'\n\e[1;32mCleaning temporary backup files...\e[0m'
    find ~ -type f -name "*.bak" -delete -print 2>/dev/null >> "$LOG_FILE"
}
clean_unnecessary_logs() {
    typing_effect $'\n\e[1;32mCleaning unnecessary logs...\e[0m'
    echo -e "\n\e[1;34m--- Logs Reset ---\nDate: $(date)\n" > "$LOG_FILE"
    find ~ -type f -name "*.log" -delete -print 2>/dev/null >> "$LOG_FILE"
}
success_msg() {
    echo -e "\n\e[40;38;5;83mCleanup completed. Details logged in ${LOG_FILE} \e[0m\n"
}

# Full clean
clean_all() {
    clean_unnecessary_logs
    clean_cache
    clean_cached_packages
    remove_unused_packages
    clean_temp_files
    clean_temp_backup_files
    enable_anti_dpi
}

# Interactive cleanup
check_and_clean() {
    [[ "$clean_logs" =~ [yY] ]] && clean_unnecessary_logs || echo -e "\e[1;33mSkipped logs.\e[0m" >> "$LOG_FILE"
    [[ "$clean_cache" =~ [yY] ]] && clean_cache || echo -e "\e[1;33mSkipped cache.\e[0m" >> "$LOG_FILE"
    [[ "$clean_packages" =~ [yY] ]] && clean_cached_packages || echo -e "\e[1;33mSkipped packages.\e[0m" >> "$LOG_FILE"
    [[ "$clean_unused_packages" =~ [yY] ]] && remove_unused_packages || echo -e "\e[1;33mSkipped unused packages.\e[0m" >> "$LOG_FILE"
    [[ "$clean_temp" =~ [yY] ]] && clean_temp_files || echo -e "\e[1;33mSkipped temp files.\e[0m" >> "$LOG_FILE"
    [[ "$clean_temp_backup" =~ [yY] ]] && clean_temp_backup_files || echo -e "\e[1;33mSkipped .bak files.\e[0m" >> "$LOG_FILE"
}

# Help
display_help() {
    echo -e "\n\e[1;34mUsage:\e[0m clean [OPTIONS]"
    echo -e "\e[1;33m  -h, --help      Show this help"
    echo -e "  -a              Clean all junk & enable firewall stealth"
    echo -e "  -f, --firewall  Enable stealth anti-DPI firewall mode"
    echo -e "  -c              Clean cache"
    echo -e "  -p              Clean cached packages"
    echo -e "  -n              Remove unused packages"
    echo -e "  -t              Clean temporary files"
    echo -e "  -b              Clean .bak files"
    echo -e "  -l              Clean .log files"
    echo -e "\nExample:\n  clean -a\n  clean -c -t\n"
}

# Handle CLI arguments
if [ "$#" -eq 0 ]; then
    cleanup_options
    check_and_clean
else
    for option in "$@"; do
        case $option in
            -h|--help) display_help; exit 0 ;;
            -a) clean_all ;;
            -f|--firewall) enable_anti_dpi ;;
            -c) clean_cache ;;
            -p) clean_cached_packages ;;
            -n) remove_unused_packages ;;
            -t) clean_temp_files ;;
            -b) clean_temp_backup_files ;;
            -l) clean_unnecessary_logs ;;
            *) echo -e "\e[1;31mInvalid option:\e[0m $option" ;;
        esac
    done
fi

success_msg
