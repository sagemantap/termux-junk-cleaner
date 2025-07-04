#!/bin/bash

##   Linux-Junk-Cleaner    :       Junk cleaner
##   Author                :       ArjunCodesmith + ChatGPT (modded by Ram Danis)
##   Version               :       1.0.1
##   Github                :       https://github.com/ArjunCodesmith (original)

author="ArjunCodesmith + Ram Danis"
version="v1.0.1"
LOG_FILE="$HOME/cleanup_log.txt"

echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE"
echo -e "\e[1;34mDate: $(date)\e[0m" >> "$LOG_FILE"
echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE"

typing_effect() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.02
    done
    echo
}

banner() {
echo -e "\e[1;31m
         ┌─────────┐     ┌─────────┐
       ──────│\e[94m [▓▓▓▓▓▓▓▓░░░░░] \e[1;31m│──────
 ─────────── │  \e[38;5;83m LINUX JΞNK \e[1;31m   │ ───────────
 ─────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ───────────
       ──────│\e[94m [░░░░░▓▓▓▓▓▓▓▓] \e[1;31m│──────
         └─────────┘     └─────────┘\e[0m"
echo -e "              \033[40;38;5;83m Version \033[30;48;5;83m $version \033[0m"
echo -e "         \033[30;48;5;83m    Copyright \033[40;38;5;83m ${author}\033[0m"
echo -e " \e[1;34m--------------------------------------------\e[0m"
}

check_socks5() {
    if lsof -i :1080 &>/dev/null; then
        echo -e "\e[1;32m[✓] SOCKS5 proxy detected on port 1080\e[0m"
    else
        echo -e "\e[1;33m[!] SOCKS5 proxy not available.\e[0m"
    fi
}

check_torsocks() {
    if command -v torsocks &>/dev/null; then
        echo -e "\e[1;32m[✓] torsocks installed\e[0m"
    else
        echo -e "\e[1;33m[!] torsocks not installed.\e[0m"
    fi
}

dpi_firewall_tips() {
    echo -e "\n\e[1;36m[~] Passive DPI Firewall Evasion Tips:\e[0m"
    echo -e " - Use SOCKS5 proxy (e.g., ssh -D 1080)"
    echo -e " - Use Tor (torsocks curl https://example.com)"
    echo -e " - Use DNS-over-HTTPS or DNSCrypt resolver"
    echo -e " - Avoid plain curl/wget without User-Agent override"
    echo -e " - Combine with obfuscated traffic: e.g., Obfsproxy, meek\n"
}

clean_cache() {
    typing_effect "🧹 Cleaning cache files..."
    find ~/.cache -type f -delete -print 2>/dev/null >> "$LOG_FILE"
}

clean_apt_cache() {
    typing_effect "🧹 Cleaning APT cached packages..."
    sudo apt-get clean >> "$LOG_FILE" 2>/dev/null
}

remove_unused_packages() {
    typing_effect "🧼 Removing unused packages..."
    sudo apt autoremove -y >> "$LOG_FILE" 2>/dev/null
}

clean_temp_files() {
    typing_effect "🗑️ Cleaning temporary files..."
    find /tmp -type f -delete -print 2>/dev/null >> "$LOG_FILE"
    find "$HOME/tmp" -type f -delete -print 2>/dev/null >> "$LOG_FILE"
}

clean_backup_files() {
    typing_effect "📦 Cleaning .bak files..."
    find "$HOME" -type f -name "*.bak" -delete -print 2>/dev/null >> "$LOG_FILE"
}

clean_logs() {
    typing_effect "📄 Cleaning .log files..."
    find "$HOME" -type f -name "*.log" -delete -print 2>/dev/null >> "$LOG_FILE"
    echo -e "\n\e[1;34mOld logs cleaned at $(date)\e[0m\n" >> "$LOG_FILE"
}

success_msg() {
    echo -e "\n\e[40;38;5;83m✅ Cleanup completed. Details logged in ${LOG_FILE} \e[0m\n"
}

interactive_cleanup() {
    read -p $'\n\e[1;35mClean logs? (y/n): \e[0m' l
    read -p $'\e[1;35mClean cache? (y/n): \e[0m' c
    read -p $'\e[1;35mClean apt cache? (y/n): \e[0m' a
    read -p $'\e[1;35mRemove unused packages? (y/n): \e[0m' u
    read -p $'\e[1;35mClean temp files? (y/n): \e[0m' t
    read -p $'\e[1;35mClean .bak files? (y/n): \e[0m' b

    [[ $l == [yY] ]] && clean_logs
    [[ $c == [yY] ]] && clean_cache
    [[ $a == [yY] ]] && clean_apt_cache
    [[ $u == [yY] ]] && remove_unused_packages
    [[ $t == [yY] ]] && clean_temp_files
    [[ $b == [yY] ]] && clean_backup_files
    success_msg
}

cli_mode() {
    for arg in "$@"; do
        case "$arg" in
            -c) clean_cache ;;
            -p) clean_apt_cache ;;
            -n) remove_unused_packages ;;
            -t) clean_temp_files ;;
            -b) clean_backup_files ;;
            -l) clean_logs ;;
            -a)
                clean_cache
                clean_apt_cache
                remove_unused_packages
                clean_temp_files
                clean_backup_files
                clean_logs
                ;;
            -h|--help)
                echo -e "\nUsage: $0 [options]"
                echo " -c   Clean user cache"
                echo " -p   Clean APT package cache"
                echo " -n   Autoremove unused packages"
                echo " -t   Clean /tmp and ~/tmp"
                echo " -b   Clean *.bak files"
                echo " -l   Clean *.log files"
                echo " -a   Clean all"
                echo " -h   Show help"
                exit 0
                ;;
            *)
                echo -e "\e[1;31m[!] Unknown option: $arg\e[0m"
                ;;
        esac
    done
    success_msg
}

# MAIN
banner
check_socks5
check_torsocks
dpi_firewall_tips

if [[ $# -eq 0 ]]; then
    interactive_cleanup
else
    cli_mode "$@"
fi
