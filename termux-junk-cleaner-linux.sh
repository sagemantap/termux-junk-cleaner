#!/bin/bash

##   Termux-Junk-Cleaner for Linux    :   Junk Cleaner + DPI Evasion
##   Author                 :   ArjunCodesmith + ChatGPT (modded by Ram Danis)
##   Version                :   v0.3.0-linux
##   Github                 :   https://github.com/sagemantap

author="ArjunCodesmith + ChatGPT (modded by Ram Danis)"
version="v0.3.0-linux"
LOG_FILE="cleanup_log.txt"

echo "-------------------------------" >> "$LOG_FILE"
echo "Date: $(date)" >> "$LOG_FILE"
echo "-------------------------------" >> "$LOG_FILE"

typing_effect() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.01
    done
    echo
}

# DPI firewall bypass tips
dpi_firewall_tips() {
    echo -e "\e[1;36m[~] Passive DPI Firewall Evasion Tips:\e[0m"
    echo " - Use SOCKS5 proxy (e.g., ssh -D 1080 user@host)"
    echo " - Use Tor: torsocks curl https://example.com"
    echo " - Use DoH or DNSCrypt resolver"
    echo " - Avoid curl/wget without User-Agent override"
    echo
}

# Tes koneksi melalui SOCKS5 proxy
test_socks5_proxy() {
    read -p "Enter SOCKS5 proxy address (e.g., 127.0.0.1:1080): " proxy
    if torsocks curl -s --socks5 "$proxy" https://check.torproject.org >/dev/null; then
        echo "[✔] SOCKS5 proxy works."
    else
        echo "[✘] SOCKS5 proxy failed."
    fi
}

# Tes koneksi DNS over HTTPS
test_doh() {
    echo "[*] Testing DNS-over-HTTPS resolver (Cloudflare)"
    if curl -s --max-time 5 https://cloudflare-dns.com/dns-query -H 'accept: application/dns-json' --get --data-urlencode 'name=example.com&type=A' >/dev/null; then
        echo "[✔] DoH is working."
    else
        echo "[✘] DoH request failed."
    fi
}

clean_cache() {
    typing_effect "[*] Cleaning user cache..."
    find ~/.cache -type f -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_temp_files() {
    typing_effect "[*] Cleaning /tmp and ~/tmp..."
    find /tmp -type f -delete -print >> "$LOG_FILE" 2>/dev/null
    find ~/tmp -type f -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_backup_files() {
    typing_effect "[*] Removing *.bak files in home directory..."
    find ~ -type f -name "*.bak" -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_logs() {
    typing_effect "[*] Removing *.log files in home directory..."
    find ~ -type f -name "*.log" -delete -print >> "$LOG_FILE" 2>/dev/null
}

clean_all() {
    clean_cache
    clean_temp_files
    clean_backup_files
    clean_logs
}

auto_cron_setup() {
    typing_effect "[*] Setting up daily auto-clean with cron..."
    (crontab -l 2>/dev/null; echo "0 3 * * * bash ~/termux-junk-cleaner-linux.sh -a") | crontab -
    echo "[✔] Cron job added: daily at 3:00 AM"
}

show_help() {
    echo "Usage: $0 [options]"
    echo "  -a       Clean all"
    echo "  -c       Clean cache"
    echo "  -t       Clean temp"
    echo "  -b       Clean .bak files"
    echo "  -l       Clean .log files"
    echo "  -d       Display DPI firewall evasion tips"
    echo "  -s       Test SOCKS5 proxy"
    echo "  -o       Test DoH resolver"
    echo "  -x       Setup cron for daily clean"
    echo "  -h       Show help"
}

if [[ $# -eq 0 ]]; then
    clean_all
    dpi_firewall_tips
    success_msg
    exit 0
fi

for arg in "$@"; do
    case "$arg" in
        -a) clean_all ;;
        -c) clean_cache ;;
        -t) clean_temp_files ;;
        -b) clean_backup_files ;;
        -l) clean_logs ;;
        -d) dpi_firewall_tips ;;
        -s) test_socks5_proxy ;;
        -o) test_doh ;;
        -x) auto_cron_setup ;;
        -h) show_help; exit 0 ;;
        *) echo "[!] Unknown option: $arg"; show_help; exit 1 ;;
    esac
done
