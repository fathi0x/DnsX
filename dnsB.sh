#!/bin/bash

echo "Enter a domain to enumerate: "
read domain

echo "[+] Checking DNS records using host command..."
host -t any $domain

echo "[+] Checking DNS records using dig command..."
dig -t any $domain

echo "[+] Checking DNS records using nslookup command..."
nslookup -query=any $domain

echo "[+] Checking MX records..."
host -t MX $domain

echo "[+] Checking SOA records..."
dig -t SOA $domain

echo "[+] Checking NS records..."
dig -t NS $domain

echo "[+] Checking TXT records..."
dig -t TXT $domain

echo "[+] Checking reverse DNS resolution..."
host $domain | grep "pointer"

echo "[+] Checking subdomains using dig command..."
dig -t NS $domain | grep "NS" | cut -d " " -f 5 | sed 's/.$//' | xargs -I {} dig @{} any -t AXFR

echo "[+] Checking subdomains using bruteforce method"
sublist3r -d $domain -o subdomains.txt

echo "[+] Checking default credentials on web interface"
nmap -p80,443,8080 --script http-enum $domain

echo "[+] Enumeration complete for domain: $domain"

