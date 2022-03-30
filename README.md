## Command Install
### 1
```
apt update && apt upgrade -y  && apt install wget -y
```
### 2
```
wget https://raw.githubusercontent.com/elsangithub/SC_Snell/main/snell.sh && chmod +x snell.sh && ./snell.sh
```
### Untuk merubah PORT dan PSK
```
nano /etc/snell-server.conf
```
#### Root only Debian 9/10 (test Debian 10)
