#!/bin/bash

# Verificăm că s-a dat un argument
if [ $# -ne 1 ]; then
    echo "Utilizare: $0 <fisier_hosts>"
    exit 1
fi

HOSTS_FILE="$1"

# Verificăm existența fișierului
if [ ! -f "$HOSTS_FILE" ]; then
    echo "Eroare: fisierul $HOSTS_FILE nu exista!"
    exit 1
fi

REGEX_IP="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

echo "Verific IP-urile din $HOSTS_FILE..."

while read -r ip rest; do
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    if [[ $ip =~ $REGEX_IP ]]; then
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
