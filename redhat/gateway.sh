echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -p
route add 0.0.0.0/0 gw 192.168.122.1
route del default
route del 0.0.0.0/0 gw 192.168.122.1
route add 0.0.0.0 netmask 0.0.0.0 gw 192.168.122.1
route del 0.0.0.0 netmask 0.0.0.0 gw 192.168.122.1
route add default gw 192.168.122.1
route del default gw 192.168.122.1
route add default gw 192.168.100.154
route add default gw 192.168.122.1 dev ens3
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface ens3 --protocol vrrp                                                                                                                        
firewall-cmd --reload
echo '192.168.100.0/24 via 192.168.122.1' > /etc/sysconfig/network-scripts/route-ens4
nmcli con reload
