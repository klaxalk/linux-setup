sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o wlp2s0: -j MASQUERADE
sudo iptables -A FORWARD -i enp0s25 -o wlp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
 
# where is internet
# where is no internet, where is internet
