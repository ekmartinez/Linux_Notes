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
* Proxys
* VPN

## Firewall
* ufw

## Intrusion Detection System
* Snort / Suricata

## Proxy

Anonymizing traffic through tor (proxy servers can be configured)

```bash
sudo pacman -S proxychains-ng tor
sudo systemctl start tor
proxychains firefox
```

## VPN

Openvpn installation & configuration for gnome.  
This will add the vpn connection option on the settings menu.

```bash
sudo pacman -S openvpn 
sudo pacman -S networkmanager-openvpn 
sudo pacman -S netoworkmanager-applet 
```
