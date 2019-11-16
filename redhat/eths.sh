# edit: ip 4
route del default
route del default
echo 1 > /proc/sys/net/ipv4/ip_forward
eth0_ip='172.31.*.*'
eth1_ip='172.31.*.*'
echo "100 eth0_net" >> /etc/iproute2/rt_tables
echo "101 eth1_net" >> /etc/iproute2/rt_tables
ip route flush table eth0_net
ip route flush table eth1_net
ip route add 0.0.0.0/0 via 172.31.0.1 dev eth0 src "$eth0_ip" table eth0_net
ip route add 0.0.0.0/0 via 172.31.0.1 dev eth0 src "$eth1_ip" table eth1_net
ip rule add from "$eth0_ip" table eth0_net
ip rule add from "$eth1_ip" table eth1_net
ip route add 0.0.0.0/0 via 172.31.0.1 dev eth0
