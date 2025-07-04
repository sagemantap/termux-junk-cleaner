#!/bin/bash

Termux-Junk-Cleaner + DPI Firewall Evasion Mode

Author : ArjunCodesmith + ChatGPT (modded by Ram Danis)

Version: v0.3.0 (DPI-safe mode)

author="ArjunCodesmith + ChatGPT" version="v0.3.0" LOG_FILE="cleanup_log.txt"

Set current date in log file

echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE" echo -e "\e[1;34mDate: $(date)\e[0m" >> "$LOG_FILE" echo -e "\e[1;34m-------------------------------\e[0m" >> "$LOG_FILE"

Typing effect

typing_effect() { local text="$1" for ((i=0; i<${#text}; i++)); do echo -n "${text:$i:1}" sleep 0.03 done echo }

Banner

echo -e "\e[1;31m ┌───────────────┐ ────────│\e[94m [████████░░░░░] \e[1;31m│─────── ────────── │  \e[38;5;83m TΞRMUX JΞNK \e[1;31m  │ ────────── ────────── │ \e[38;5;83m C L E A N E R \e[1;31m │ ────────── ────────│\e[94m [░░░░████████] \e[1;31m│─────── └───────────────┘\e[0m" echo -e "              \033[40;38;5;83m Version \033[30;48;5;83m $version \033[0m" echo -e "         \033[30;48;5;83m    Author  \033[40;38;5;83m ${author}\033[0m" echo -e " \e[1;34m--------------------------------------------\e[0m"

Cleanup options

cleanup_options() { read -p $'\n\e[1;35m Do you want to clean unnecessary logs? (y/n): \e[0m' clean_logs read -p $'\e[1;35m Do you want to clean cache files? (y/n): \e[0m' clean_cache read -p $'\e[1;35m Do you want to clean cached packages? (y/n): \e[0m' clean_packages read -p $'\e[1;35m Do you want to remove unused packages? (y/n): \e[0m' clean_unused_packages read -p $'\e[1;35m Do you want to clean temporary files? (y/n): \e[0m' clean_temp read -p $'\e[1;35m Do you want to clean backup .bak files? (y/n): \e[0m' clean_temp_backup }

Cleanup functions

clean_cache() { typing_effect $'\n\e[1;32mCleaning cache files...\e[0m' find ~/.cache/ -type f -delete -print 2>/dev/null >> "$LOG_FILE" find ~/../usr/var/cache -type f -delete -print 2>/dev/null >> "$LOG_FILE" }

clean_cached_packages() { typing_effect $'\n\e[1;32mCleaning cached packages...\e[0m' apt-get clean 2>/dev/null }

remove_unused_packages() { typing_effect $'\n\e[1;32mRemoving unused packages...\e[0m' apt autoremove -y 2>/dev/null >> "$LOG_FILE" }

clean_temp_files() { typing_effect $'\n\e[1;32mCleaning temporary files...\e[0m' find ~/tmp/ -type f -delete -print 2>/dev/null >> "$LOG_FILE" }

clean_temp_backup_files() { typing_effect $'\n\e[1;32mCleaning .bak backup files...\e[0m' find ~ -type f -name "*.bak" -delete -print 2>/dev/null >> "$LOG_FILE" }

clean_unnecessary_logs() { typing_effect $'\n\e[1;32mCleaning unnecessary logs...\e[0m' echo -e "\n[Cleared on: $(date)]\n" > "$LOG_FILE" find ~ -type f -name "*.log" -delete -print 2>/dev/null >> "$LOG_FILE" }

Final message

success_msg() { echo -e "\n\e[40;38;5;83mCleanup completed. Logged to ${LOG_FILE}\e[0m\n" }

DPI firewall evasion notice

echo -e "\n\e[1;34m[~] DPI Firewall Evasion Tips:\e[0m" echo -e "\e[1;33m - Use torsocks: \e[0mtorsocks curl https://site" echo -e "\e[1;33m - Use SOCKS5 Proxy: \e[0mssh -D 1080 user@host" echo -e "\e[1;33m - Avoid curl/wget without spoofed User-Agent\e[0m" echo -e "\e[1;33m - Use DNS over HTTPS or DNSCrypt\e[0m"

Execution logic

check_and_clean() { [[ "$clean_logs" == "y" || "$clean_logs" == "Y" ]] && clean_unnecessary_logs [[ "$clean_cache" == "y" || "$clean_cache" == "Y" ]] && clean_cache [[ "$clean_packages" == "y" || "$clean_packages" == "Y" ]] && clean_cached_packages [[ "$clean_unused_packages" == "y" || "$clean_unused_packages" == "Y" ]] && remove_unused_packages [[ "$clean_temp" == "y" || "$clean_temp" == "Y" ]] && clean_temp_files [[ "$clean_temp_backup" == "y" || "$clean_temp_backup" == "Y" ]] && clean_temp_backup_files }

Help

display_help() { echo -e "\nUsage: $0 [options]" echo -e " -h          Show help" echo -e " -a          Clean all" echo -e " -c          Clean cache" echo -e " -p          Clean apt cache" echo -e " -n          Remove unused packages" echo -e " -t          Clean temp" echo -e " -b          Clean *.bak" echo -e " -l          Clean *.log" }

Parse args

if [ $# -eq 0 ]; then cleanup_options check_and_clean else while [[ "$1" != "" ]]; do case $1 in -a) clean_unnecessary_logs; clean_cache; clean_cached_packages; remove_unused_packages; clean_temp_files; clean_temp_backup_files;; -c) clean_cache;; -p) clean_cached_packages;; -n) remove_unused_packages;; -t) clean_temp_files;; -b) clean_temp_backup_files;; -l) clean_unnecessary_logs;; -h|--help) display_help; exit 0;; *) echo -e "\e[1;31mInvalid option $1\e[0m"; display_help; exit 1;; esac shift done fi

success_msg

