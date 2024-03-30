# Security

This area has instuctions on installing and configuring security and privacy software on Linux.

* [Hardware Vulnerabilities](#Hardware-Vulnerabilities)
* [Malware Scanner](#Malware-Scanner)
* [Firewall](#Firewall)
* [Intrusion Detection System](#Intrusion-Detection-System) 
* [Encrypted DNS](#Encrypted-DNS)
* [Virtual Private Network](#Virtual-Private-Network)

## Hardware Vulnerabilities

Scan your system to see if you have known hardware vulnerabilities:

```bash
grep -r . /sys/devices/system/cpu/vulnerabilities/
```

## Malware Scanner

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

## Firewall

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

The following is a multi-step process of installing, configuring and using snort.

Installation from the AUR:

```bash
yay -S snort 
```

The configuration file is located at: /etc/snort/snort.lua.

Modified Section 5 of the configuration and make sure to include the following lines:

```bash
enable_builtin_rules = true,
include = "/etc/snort/rules/local.rules",
```

This tells snort to use the builtin rules along with the local rules which will be populated by Pulled Pork.

**Pulled Pork 3**

To install pulledpork3 follow the below procedures:

```bash
git clone https://github.com/shirkdog/pulledpork3.git
cd pulledpork3

sudo mkdir /usr/local/etc/pulledpork/
sudo cp etc/pulledpork.conf /usr/local/etc/pulledpork/

sudo mkdir /usr/local/bin/pulledpork/
sudo cp pulledpork.py /usr/local/bin/pulledpork/
sudo cp -r lib/ /usr/local/bin/pulledpork/
```

This will download pulledpork3 from the oficial sources and copy the python file, configuration and libraries to the proper paths.

Just to double check:

The python file should be at: /usr/local/bin/pulledpork/pulledpork.py

The configuration file should be at: /usr/local/etc/pulledpork/pulledpork.conf

To see if working:

```bash
/usr/local/bin/pulledpork/pulledpork.py
```

Now into the configuration file:

1. Select rulesets to download.
2. Specify snort path (/bin/snort).
3. Uncoment and edit local_rules path.

Now run pulledpork:

```bash
sudo /usr/local/bin/pulledpork/pulledpork.py  -c /usr/local/etc/pulledpork/pulledpork.conf 
```

Note that you may get the following error:

```bash
ERROR: `sorule_path` is configured but is not a directory:  /usr/local/etc/so_rules/
```

Fix by creating the directory:

```bash
sudo mkdir /usr/local/etc/so_rules/
```

After running againg you may get the following error:

```bash
WARNING: Unable to load rules archive:  422 Client Error: Unprocessable Entity for url: https://snort.org/rules/snortrules-snapshot-31830.tar.gz?oinkcode=<hidden>
```

For this one you will need to edit the actual pulledpork.py file and hard code the rule's http address.

So you need to change this:

```python
RULESET_URL_SNORT_REGISTERED = 'https://snort.org/rules/snortrules-snapshot-<VERSION>.tar.gz'
```

To the latest rules on snorts.org website.  A the time of this writting the latest version was 31470. So we make the change as follows:

```python
RULESET_URL_SNORT_REGISTERED = 'https://snort.org/rules/snortrules-snapshot-31470.tar.gz'
```

Then we run pulledpork again and we may get the following error:
```bash
FileNotFoundError: [Errno 2] No such file or directory: '/usr/local/etc/rules/pulledpork.rules'
```

We fix this one by:

```bash
cd /usr/loca/etc/
mkdir rules
sudo nvim pulledpork.rules
:wq!
```

Then we run pullpork again and we should have the following results:

```bash
Processing Registered ruleset
loaded local rules file:  Rules(loaded:1, enabled:1, disabled:0) from /etc/snort/rules/local.rules
Preparing to modify rules by sid file
Completed processing all rulesets and local rules:
 - Collected Rules:  Rules(loaded:50018, enabled:9800, disabled:40218)
 - Collected Policies:
    - Policy(name:security, rules:22241)
    - Policy(name:balanced, rules:9800)
    - Policy(name:none, rules:0)
    - Policy(name:connectivity, rules:587)
    - Policy(name:max-detect, rules:40259)
Writing rules to:  /usr/local/etc/rules/pulledpork.rules
Program execution complete.
```

Running snort example:

```bash
sudo snort -c /etc/snort/snort.lua -i wlan0 --daq-dir /usr/lib/daq -A alert_fast 
``` 

After testing, the programs works in the sense that it runs in listenting mode and displays alerts to the terminal, the only problem encountered that hasn't been solved is that it is not producing any logs.

Snort Command Line:

*https://docs.snort.org/start/help*

Listing command line options available:

```bash
snort -?
```

Getting help on the "-A" command line option:

```bash
snort --help-options A
```

Some Snort flags:

-c = configuration file

-i = interface name

-r = Pcap to read.

--daq-dir = location of daq (for some reason throws error if not included).

-A = Specifies Alert mode. (alert_fast, alert_full, etc)

-R = This flag is used to use a specify a rules file. (Usefull when analyzing pcap files)

-T = Test configuration file.

-l = Specifies location of logs.

## Encrypted DNS

Encrypt DNS traffic with dnscrypt-proxy.

```bash
sudo pacman -S dnscrypt-proxy
```

The configuration file is located at: */etc/dnscrypt-proxy/dnscrypt-proxy.toml*

In the configuration file:

listen_addresses = ['127.0.0.1:53', '[::1]:53']

If everything is correct there should be a resolvers file at: /var/cache/dnscrypt-proxy/public-resolvers.md.  If the file is not at the location finish setting up the service, restart and check again.  If it doesnt show up, then something may be wrong.

This is a list of dns servers available to use by dnscrypt-proxy, but not all of the are secure.  To ensure you use only secured DNS servers you must edit some options in the configuration file:

```bash
dnscrypt_servers = true
doh_servers = true
require_dnssec = true
require_nolog = true
require_nofilter = true
```
Start / Enable Service

```bash
sudo systemctl start dnscrypt-proxy.service
sudo systemctl enable dnscrypt-proxy.service
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
