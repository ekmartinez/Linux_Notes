# Linux_Notes 

General Notes on the Linux Operating System

## General Commands

This area will contain the most common commands on linux.

* File navigation
* Permissions
* Searching
* System administration

### Searching

Finding files:

Find the file named “flag1.txt” in the current directory:

```bash
find . -name flag1.txt
```

Find the file names “flag1.txt” in the /home directory

```bash
find /home -name flag1.txt
```

Find the directory named config under “/”

```bash
find / -type d -name config
```

Find files with the 777 permissions (files readable, writable, and executable by all users):

```bash
find / -type f -perm 0777
```

Find executable files:

```bash
find / -perm a=x
```

Find all files for user “frank” under “/home”

```bash
find /home -user frank
```

Find files that were modified in the last 10 days:

```bash
find / -mtime 10
```

Find files that were accessed in the last 10 day:

```bash
find / -atime 10
```

Find files changed within the last hour (60 minutes):

```bash
find / -cmin -60
```

Find files accesses within the last hour (60 minutes)

```bash
find / -amin -60
```

Find files with a 50 MB size:

```bash
find / -size 50M
```

Find files with the SUID bit set.

```bash
find / -perm -u=s -type f 2>/dev/null
```

**Folders and files that can be written to or executed from:**

Find world-writeable folders:

```bash
find / -writable -type d 2>/dev/null 
```
```bash
find / -perm -222 -type d 2>/dev/null
```
```bash
find / -perm -o w -type d 2>/dev/null
```

Find world-executable folders:

```bash
find / -perm -o x -type d 2>/dev/null 
```

Find writable folders in a cleaner way.

```bash
find / -writable 2>/dev/null | cut -d "/" -f 2,3 | grep -v proc | sort -u 
```

Find development tools and supported languages:

```bash
find / -name perl*
```
```bash
find / -name python*
```
```bash
find / -name gcc*
```

## Networking

This area will have instructions on networking operations.

* Wireless Connections
* Bluetooth Devices
* ip command
* ss command
* DNS analysis

### Wireless Connections

The iwctl tool allows operations on wireless devices.  To use it you need to install the iwd package:

```bash
sudo pacman -S iwd
```

Start the iwd service:

```bash
sudo systemctl start iwd.service
```

Enable the iwd service:

```bash
sudo systemctl enable iwd.service
```

Get to the iwctl prompt:

```bash
iwctl
```

To get list of available network interfaces:

```bash
[iwd]# device list
```

To scan for wireless networks in range:

```bash
[iwd]# station <wlan0> scan
```

Note that the command above won't produce any output but the results will remain on memory. To get the results you use the following command:

```bash
[iwd]# station <wlan0> get-networks
```

After getting the available networks you can connect by SSID:

```bash
[iwd]# station <wlan0> connnect <SSID>
```

Enter the password and you are in.

## Bluetooth Connections

This area contains basic information regarding the configuration of bluetooth devices like mouse and headsets.

The necessary packages are:

```bash
sudo pacman -S bluez bluez-utils
```
In my case, my system didn't had bluetooth profiles for my headset so I had to install an additional package:

```bash
sudo pacman -S pipewire-pulse
```

Start / enable bluetooth

```bash
sudo systemctl start bluetooth.service
```
```bash
sudo systemctl enable bluetooth.service
```

Get to the bluetoothctl prompt:

```bash
bluetoothctl
```

Enter discovery mode and scan for available devices:
```bash
[bluetooth]# scan on
```

Take note of the MAC address of the device you are interested in.

To pair with the device:

```bash
[bluetooth]# pair <mac address>
```

To connect to the device:

```bash
[bluetooth]# connect <mac address>
```

You will only need to perform these procedures once
per device if you enabled the bluetooth service.

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

Install Wireguard client

```bash
sudo pacman -Sy wireguard-tools 
```

Move configuration file
```bash
mv configuration.conf /etc/wireguard/configuration.conf
```

Connect
```bash
sudo wg-quick up configuration (without the extension)
```

Depending on your network configuration you may get a resolvconf error. Install it with the openresolv package, not the systemd one since it doesn't work. (at least for me).

```bash
sudo pacman -S openresolv
```

See if working
```bash
sudo wg
```
Enable on boot

```bash
sudo systemctl enable wg-quick@iface.service#Install Wireguard client
```
