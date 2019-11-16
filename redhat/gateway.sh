# edit: dev
echo 1 > /proc/sys/net/ipv4/ip_forward
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface ens3 --protocol vrrp                                                                                                                        
firewall-cmd --reload
echo '192.168.100.0/24 via 192.168.122.1' > /etc/sysconfig/network-scripts/route-ens4
nmcli con reload
