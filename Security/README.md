# Security

This area has instuctions on installing and configuring security and privacy software on Linux.

* Hardware Vulnerabilities
* Malware Scanner
* Firewall
* IDS
* VPN
* DNS

## Hardware Vulnerabilities

Scan your system to see if you have known hardware vulnerabilities:

```bash
grep -r . /sys/devices/system/cpu/vulnerabilities/
```

## Malware scanner

Scan for malware with rkhunter.

Location of configuration file: etc/rkhunter.conf
Location of last results: /var/log/rkhunter.log

Since rkhunter uses ifconfig and unhide to run some of the scans we install them all with:

```bash
sudo pacman -S rkhunter net-tools unhide
```

Before using for first time:

```bash
sudo rkhunter --propupd
```
The above command takes a snapshot of critical system files and whitelist them, the if anything changes it will alert.

To update:

```bash
sudo rkhunter --update
```

To run a scan:

```bash
sudo rkhunter --check --sk
```

To validate config file:

```bash
sudo rkhunter --config-check
```

## Firewal

### UFW - Uncomplicated Firewall 

Uncomplicated Firewall is an easy to use yet powerfull firewall front-end for iptables.

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

The following was test on gnome:

```bash
sudo pacman -S openvpn networkmanager-openvpn network-manager-applet 
```

After installing, use the graphical user interface to add a configuration file and connect.

**Wireguard**

Assuming you have access to a VPN service with Wireguard support.  

1. Download a configuration file(otherwise you need to setup manually).
2. Install the Wireguard client.
3. Move (or create) configuration.conf at /etc/wireguard
4. Start / enable service.

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
# Without the extension
sudo wg-quick up configuration 
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
sudo systemctl enable wg-quick@iface.service
```
