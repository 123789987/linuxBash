cd
yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-7.el8.noarch.rpm
rpm -Uvh epel-release-8-7.el8.noarch.rpm
yum update -y
setenforce 0
vi /etc/selinux/config
echo '1' > /proc/sys/net/ipv4/ip_forward
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p
