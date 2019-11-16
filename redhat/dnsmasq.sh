cd
yum install dnsmasq -y
cat 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
cat 'strict-order' >> /etc/dnsmasq.conf
cat 'listen-address=10.8.0.1' >> /etc/dnsmasq.conf
cat 'addn-hosts=/etc/addion_hosts' >> /etc/dnsmasq.conf
cat 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf
cat 'nameserver 8.8.8.8' >> /etc/resolv.conf
cat '127.0.0.1 localhost' >> /etc/addion_hosts
service dnsmasq start 
chkconfig dnsmasq on
