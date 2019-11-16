# edit: dev
yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-7.el8.noarch.rpm
rpm -Uvh epel-release-8-7.el8.noarch.rpm
yum install openvpn -y
echo 'client.conf' > /etc/openvpn/client/client.conf
openvpn --daemon --config /etc/openvpn/client/client.conf
yum install net-tools -y
echo 1 > /proc/sys/net/ipv4/ip_forward
#systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface tun0 --protocol vrrp                                                                                                                        
firewall-cmd --reload
echo '192.168.100.0/24 via 10.8.0.1' > /etc/sysconfig/network-scripts/route-ens4
nmcli con reload
