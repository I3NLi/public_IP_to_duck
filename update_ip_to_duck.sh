#!/bin/bash
SUBDOMAIN="<subdomain>"
TOKEN="<token>"

# Retrieve public IP address
PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
if [ -z "$PUBLIC_IP" ]; then
    echo "Failed to retrieve public IP address. Exiting."
    exit 1
fi

# Retrieve DNS IP address
DNS_IP=$(host -t a bbb.e-course.app 8.8.8.8 | grep address | awk '{print $4}')
if [ -z "$DNS_IP" ]; then
    echo "Failed to retrieve DNS IP address. Exiting."
    exit 1
fi

# Print retrieved public IP address and DNS IP address
echo "Your public IP address is: $PUBLIC_IP"
echo "Your DNS IP address is: $DNS_IP"

# Check if public IP address and DNS IP address are different, if so, update DDNS
if [ "$DNS_IP" != "$PUBLIC_IP" ]; then
    echo "Updating DDNS"
    echo "Updating ${SUBDOMAIN}.duckdns.org with IP: ${PUBLIC_IP}"
    curl -s "https://www.duckdns.org/update/${SUBDOMAIN}/${TOKEN}/${PUBLIC_IP}"
else
    echo "No change detected. Exiting."
fi
