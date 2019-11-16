cd
yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-7.el8.noarch.rpm
rpm -Uvh epel-release-8-7.el8.noarch.rpm
yum update -y
yum install openvpn -y
wget 'https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz' -O ~/easyrsa.tgz
tar xzf ~/easyrsa.tgz -C ~/
cd ~/EasyRSA-3.0.5/
./easyrsa init-pki
./easyrsa --batch build-ca nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full client nopass
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
./easyrsa gen-dh
cp ~/EasyRSA-3.0.5/pki/{ca.crt,crl.pem,dh.pem,issued/server.crt,private/{ca.key,server.key}} /etc/openvpn/server
openvpn --genkey --secret /etc/openvpn/server/tc.key
echo 'port 443
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt tc.key
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nobody
persist-key
persist-tun
status openvpn-status.log
verb 3
crl-verify crl.pem
explicit-exit-notify' > /etc/openvpn/server/server.conf

yum install iptables -y
yum install policycoreutils-python-utils -y

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to 172.31.8.187
iptables -I INPUT -p udp --dport 443 -j ACCEPT
iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
semanage port -a -t openvpn_port_t -p udp 443
systemctl start openvpn-server@server.service

echo 'client
dev tun
proto udp
remote public_ip 443
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
ignore-unknown-option block-outside-dns
block-outside-dns
verb 3'
echo '<ca>'
cat /etc/openvpn/server/ca.crt
echo '</ca>'
echo '<cert>'
sed -ne '/BEGIN CERTIFICATE/,$ p' ~/EasyRSA-3.0.5/pki/issued/client.crt
echo '</cert>'
echo '<key>'
cat ~/EasyRSA-3.0.5/pki/private/client.key
echo '</key>'
echo '<tls-crypt>'
sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/server/tc.key
echo '</tls-crypt>'
