#!/bin/bash

HOSTS_FILE="$HOME/etc/hosts"

# Verificăm că fișierul există
if [ ! -f "$HOSTS_FILE" ]; then
    echo "Eroare: fisierul $HOSTS_FILE nu exista!"
    exit 1
fi

# Regex pentru IPv4 valid
REGEX_IP="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

echo "Verific IP-urile din $HOSTS_FILE..."

while read -r ip rest; do
    # Sarim liniile goale sau comentariile
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    if [[ $ip =~ $REGEX_IP ]]; then
        # Verificăm fiecare octet să fie 0–255
        valid=true
        IFS='.' read -ra octets <<< "$ip"
        for o in "${octets[@]}"; do
            if (( o < 0 || o > 255 )); then
                valid=false
                break
            fi
        done

        if $valid; then
            echo "IP valid: $ip"
        else
            echo "IP invalid (octet în afara intervalului): $ip"
        fi
    else
        echo "IP invalid (format gresit): $ip"
    fi

done < "$HOSTS_FILE"
