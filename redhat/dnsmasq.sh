cd
yum install dnsmasq -y
echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
echo 'strict-order' >> /etc/dnsmasq.conf
echo 'listen-address=10.8.0.1' >> /etc/dnsmasq.conf
echo 'addn-hosts=/etc/addion_hosts' >> /etc/dnsmasq.conf
echo 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
echo '127.0.0.1 localhost' >> /etc/addion_hosts
service dnsmasq start 
chkconfig dnsmasq on
