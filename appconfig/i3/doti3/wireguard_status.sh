#!/bin/bash
# author: Ondrej Prochazka

# List all WireGuard interfaces
INTERFACES=$(wg show interfaces)

if [ -z "$INTERFACES" ]; then
    echo "🔓 VPN OFF"
    echo "VPN OFF"
    echo "#FF0000"
    exit 0
else
    echo "🔒 $INTERFACES"
    echo "$INTERFACES"
    echo "#00FF00"
fi

# TODO: Uncomment the following section if you want to check for active connections
# ACTIVE=0
# NOW=$(date +%s)

# for IFACE in $INTERFACES; do
#     # Get last handshake timestamp
#     HANDSHAKE=$(wg show "$IFACE" latest-handshakes | awk '{print $2}')
#     if [ "$HANDSHAKE" -gt 0 ] && [ $((NOW - HANDSHAKE)) -lt 120 ]; then
#         ACTIVE=1
#         break
#     fi
# done

# if [ "$ACTIVE" -eq 1 ]; then
#     echo "🔒 VPN ON"
#     echo "VPN ON"
#     echo "#00FF00"
# else
#     echo "🛑 VPN Idle"
#     echo "VPN Idle"
#     echo "#FFA500"
# fi
