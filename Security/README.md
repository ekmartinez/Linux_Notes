# Security

This area has instuctions on installing and configuring security and privacy software on Linux.

* Hardware Vulnerabilities
* Malware Scanner
* Firewall
* IDS / IPS
* DNS
* VPN

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

Installation UFW:

```bash 
sudo pacman -Sy ufw
```

Start service:

```bash
sudo systemctl start ufw.service
```

Enable service:

```bash
sudo systemctl enable ufw.service
```

Basic rules:

To deny all:

```bash
sudo ufw defualt deny
```

To allow a rate limited ssh:

```bash
sudo limit ssh
```

To allow all traffic from subnet:

```bash
sudo ufw from 192.168.0.0/24
```

Onetime command to enable the firewall:

```bash
sudo ufw enable
```

See if working:

```bash
sudo ufw status 
```

## Intrusion Detection System

### Snort 3

Install snort3 from the AUR:

```bash
yay -S snort 
```

The configuration file is located at: /etc/snort/snort.lua, but you can use your own configuration when running snort.  For example to run snort in alert mode:

```bash
sudo snort -c /etc/snort/snort.lua -i wlan0 --daq-dir /usr/lib/daq -A alert_fast 
``` 

Where:

-c = configuration file

-i = interface name

--daq-dir = location of daq (for some reason throws error if not included).

-A = In this case alert_fast but it can be started in log mode.


**Pulled Pork**

In process.....


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

Install Wireguard client:

```bash
sudo pacman -Sy wireguard-tools 
```

Move configuration file:

```bash
mv configuration.conf /etc/wireguard/configuration.conf
```

Connect:

```bash
# Without the extension
sudo wg-quick up configuration 
```

Depending on your network configuration you may get a resolvconf error. Install it with the openresolv package, not the systemd one since it doesn't work. (at least for me).

```bash
sudo pacman -S openresolv
```

See if working:

```bash
sudo wg
```

Enable on boot:

```bash
sudo systemctl enable wg-quick@iface.service
```
