#!/bin/bash
IP=$(wget -qO- ipv4.icanhazip.com)

#Preparation
clear
cd;
apt-get update;

#Remove unused Module
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

#install toolkit
apt-get install libpcre3 libpcre3-dev zlib1g-dev dbus zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr dnsutils sudo at htop iptables syslog-ng bsdmainutils cron lsof iptables iptables-persistent -y

#Set Timezone GMT+7
timedatectl set-timezone Asia/Jakarta;
apt install neofetch -y

#profile
echo -e 'profile' >> /root/.profile
wget -O /usr/bin/profile "https://script.lingssh.com/profile.sh";
chmod +x /usr/bin/profile
apt install neofetch -y;

#Install Fail2Ban
apt-get -y install fail2ban;
service fail2ban restart;

#Login mode to Shells
echo "/bin/false" >> /etc/shells;
echo "/usr/sbin/nologin" >> /etc/shells;

#Install VNSTAT WebView
apt -y install vnstat;
/etc/init.d/vnstat restart;
apt -y install libsqlite3-dev;
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz;
tar zxvf vnstat-2.6.tar.gz;
cd vnstat-2.6;
./configure --prefix=/usr --sysconfdir=/etc && make && make install;
cd;
chown vnstat:vnstat /var/lib/vnstat -R;
systemctl enable vnstat;
/etc/init.d/vnstat restart;
rm -f /root/vnstat-2.6.tar.gz;
rm -rf /root/vnstat-2.6;

#Install Speedtest
curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
sudo apt-get install speedtest -y

#install hysteria
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date
wget https://github.com/surge-networks/snell/releases/download/v3.0.1/snell-server-v3.0.1-linux-amd64.zip && unzip snell-server-v3.0.1-linux-amd64.zip && mv snell-server /usr/local/bin/
rm -f snell-server-v3.0.1-linux-amd64.zip
cat > /etc/systemd/system/snell.service <<-END
[Unit]
Description=Snell Proxy Service
After=network.target

[Service]
Type=simple
LimitNOFILE=infinity
ExecStart=/usr/local/bin/snell-server -c /etc/snell-server.conf
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=snell-server

[Install]
WantedBy=multi-user.target
END
psk=$(openssl rand -base64 32)
cat >/etc/snell-server.conf <<EOF
[snell-server]
listen = 0.0.0.0:443
psk = $psk
ipv6 = false
obfs = tls
EOF
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable snell
systemctl start snell

#install bbr
echo 'fs.file-max = 500000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.core.rmem_max=26214400
net.core.rmem_default=26214400
net.ipv4.tcp_mtu_probing = 1
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf
sysctl --system;

#change limit
echo '* soft nofile 500000' >> /etc/security/limits.conf
echo '* hard nofile 500000' >> /etc/security/limits.conf
ulimit -n 500000

#finish
apt autoremove -y
apt clean
neofetch
echo -e ""
echo -e "===================================="
echo -e "SNELL SERVER BERHASIL DI INSTALL"
echo -e "DETAIL AKUN ANDA"
echo -e ""
echo -e "Host: $IP"
echo -e "Port: 443"
echo -e "PSK: $psk"
echo -e "Obfs Mode: TLS"
echo -e "===================================="
echo -e "JIKA ANDA INGIN MENGGANTI MODE OBFS/PORT/PSK"
echo -e "EDIT CONF FILE NYA DI /etc/snell-server.conf"
echo -e "LALU RESTART SERVICE NYA"
systemctl status snell
rm -rf /root/snell.sh