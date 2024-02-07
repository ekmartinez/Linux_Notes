# Linux_Notes 

General Notes on the Linux Operating System

## General Commands

This area will contain the most common commands on linux.

* File navigation
* Permissions
* Searching
* System administration

## Networking

This area will have instructions on networking operations.

* Network manager
* Wireless interfaces
* Bridges
* DNS analysis
* Routing analysis

## Security

This area will have instuctions on installing and configuring security and privacy software on Linux.

* Firewalls
* IDS
* VPN

## Firewall
* ufw

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

## VPN

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




