# Linux_Notes 

General Notes on the Linux Operating System

## General Commands

This area will contain the most common commands on linux.

* File navigation
* Permissions
* Searching
* System administration

### Searching

Find files:

find . -name flag1.txt: find the file named “flag1.txt” in the current directory
find /home -name flag1.txt: find the file names “flag1.txt” in the /home directory
find / -type d -name config: find the directory named config under “/”
find / -type f -perm 0777: find files with the 777 permissions (files readable, writable, and executable by all users)
find / -perm a=x: find executable files
find /home -user frank: find all files for user “frank” under “/home”
find / -mtime 10: find files that were modified in the last 10 days
find / -atime 10: find files that were accessed in the last 10 day
find / -cmin -60: find files changed within the last hour (60 minutes)
find / -amin -60: find files accesses within the last hour (60 minutes)
find / -size 50M: find files with a 50 MB size
find / -perm -u=s -type f 2>/dev/null: Find files with the SUID bit, which allows us to run the file with a higher privilege level than the current user.

Folders and files that can be written to or executed from:

find / -writable -type d 2>/dev/null : Find world-writeable folders
find / -perm -222 -type d 2>/dev/null: Find world-writeable folders
find / -perm -o w -type d 2>/dev/null: Find world-writeable folders

find / -perm -o x -type d 2>/dev/null : Find world-executable folders

Find development tools and supported languages:

find / -name perl*
find / -name python*
find / -name gcc*

## Networking

This area will have instructions on networking operations.

* netstat
* route
* DNS analysis

### netstat

netstat -a: shows all listening ports and established connections.
netstat -at or netstat -au can also be used to list TCP or UDP protocols respectively.
netstat -l: list ports in “listening” mode. These ports are open and ready to accept incoming connections. This can be used with the “t” option to list only ports that are listening using the TCP protocol.
netstat -s: list network usage statistics by protocol (below) This can also be used with the -t or -u options to limit the output to a specific protocol.
netstat -tp: list connections with the service name and PID information.
netstat -i: Shows interface statistics. We see below that “eth0” and “tun0” are more active than “tun1”.

netstat -ano
-a: Display all sockets
-n: Do not resolve names
-o: Display timers

## Security

This area has instuctions on installing and configuring security and privacy software on Linux.

* Firewalls
* IDS
* VPN
* DNS
## Firewall

### UFW - Uncomplicated Firewall 

Uncomplicated Firewall is an easy to use yet powerfull firewall front-end for iptables on Linux.

```bash
#Installation
sudo pacman -Sy ufw

#Start service with systemd
sudo systemctl start ufw.service

#Enable ufw on startup using systemd
sudo systemctl enable ufw.service

#Basic rules (Example modify as needed)
sudo ufw defualt deny
sudo limit ssh
sudo ufw from 192.168.0.0/24

#Onetime command to enable the firewall
sudo ufw enable

#See if working
sudo ufw status 
```
## Intrusion Detection System

### Suricata - Installation & Configuration

These instructions where successfully tested on Ubuntu Server & Fedora 37, but haven't been able to configure the update-sources correctly on Arch.

**Quickstart Guide**

https://docs.suricata.io/en/latest/quickstart.html

```bash
suricata -h (--help)

```
**Installation**

sudo apt-get install suricata jq

**Configuration**

Get network interface name
```bash
ip addr
```
Edit Configuration File
```bash
sudo nvim /etc/suricata/suricata.yaml

HOME_NET = ['192.168.0.0/24']

Capture settings
	af-packet:
		interface: enp1s0
		cluster-id: 99
		cluster-type: cluster_flow
		defrag: yes
		use-mmap: yes
		tpacket-v3: yes
```

Update, Start & Enable Suricata Service
```bash
sudo suricata-update
sudo systemctl start suricata
sudo systemctl enable suricata
```

Test configuration
```bash
sudo tail /var/log/suricata/suricata.log

#Statistics
sudo tail -f /var/log/suricata/stats.log

#Test if working
sudo tail -f /var/log/suricata/fast.log
curl http://testmynids.org/uid/index.html

#A nicer output:
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'

#More detail about each alert
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="stats")|.stats.capture.kernel_packets'
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="stats")'

#See additional sources
sudo suricata-update list-sources

#Enable source
sudo suricata-update enable-source <source_name>

Update Sources
sudo suricata-update update-sources
```
## Virtual Private Network

**OpenVpn**

```bash
sudo pacman -S openvpn 
sudo pacman -S networkmanager-openvpn 
sudo pacman -S netoworkmanager-applet 
```

**Wireguard**

Assuming you have access to a VPN service with Wireguard support.  

1. Download a configuration file(otherwise you need to setup manually).
2. Install the Wireguard client.
3. Move (or create) configuration.conf at /etc/wireguard

General Steps
```bash
#Install Wireguard client
sudo pacman -Sy wireguard-tools 

#Move configuration file
mv configuration.conf /etc/wireguard/configuration.conf

#Connect
sudo wg-quick up configuration (without the extension)

#See if working
sudo wg
```




