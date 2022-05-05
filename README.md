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

### Format Openclash
```
proxies:
  - name: Nama Akun
    type: snell
    server: 128.199.79.115
    port: 443
    psk: elsande123
    version: '3'
    obfs-opts:
        mode: tls
        host: bug.com
    sni: bug.com
    ```
    
#### Root only Debian 9/10 (test Debian 10)
#### Source : LingSSH
