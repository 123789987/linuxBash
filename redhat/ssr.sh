# edit: password
cd
yum install python3 -y
yum install git -y
git clone https://github.com/shadowsocksrr/shadowsocksr.git
cd shadowsocksr
./initcfg.sh
echo '{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "port_password": {
        "21": "",
        "443": "",
        "1433": "",
        "3306": "",
        "8388": ""
    },
    "method": "aes-256-ctr",
    "protocol": "auth_aes128_md5",
    "protocol_param": "",
    "obfs": "http_simple",
    "obfs_param": "",
    "speed_limit_per_con": 0,
    "speed_limit_per_user": 0,

    "additional_ports" : {}, // only works under multi-user mode
    "additional_ports_only" : false, // only works under multi-user mode
    "timeout": 120000,
    "udp_timeout": 60000,
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}' > ~/shadowsocksr/user-config.json
python3 ~/shadowsocksr/shadowsocks/server.py -d start
