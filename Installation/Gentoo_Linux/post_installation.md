# Post-Installation Tasks

**Setup Networking**

So we took care of this when installing Gentoo, right?  Well technically yes, but there are additional steps that we need to take in order to connect to a network.

First, I don't know why dhcpcd re-writes the `etc/resolv.conf` file with some blank content.  Add the following to the file:

```bash
nameserver 192.168.0.1
```

Then run:

```bash
chattr +i
```
This will prevent any other program to edit the content of the file. Now you should at least be able to connect through your wired ethernet interface.

For wireless you will see an wpa_supplicant error while booting up with a message stating that the configuration file does not exists. Create the file `/etc/wpa_supplicant/wpa_supplicant.conf` and add the following configuration:

```bash
# Allow users in the 'wheel` group to control wpa_supplicant
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel

#Make this file writable for wpa_gui / wpa_cli
update_config=1
```

You can also try this other configuration:

```bash
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
#ap_scan=0
#update_config=1
 
network={
        ssid="YourSSID"
        psk="your-secret-key"
        scan_ssid=1
        proto=RSN
        key_mgmt=WPA-PSK
        group=CCMP TKIP
        pairwise=CCMP TKIP
        priority=5
}
```
Ensure the services are running:

```bash
rc-service dhcpcd start
```
```bash
rc-service wpa_supplicant start
```

Now lets try to connect:

```bash
set +o history
```
```bash
wpa_supplicant -i wlan0 -c <(wpa_passphrase ssid password) &
```
```bash
set -o history
```
The set history commands enables and disables recording the password into the history.  You should then see some indications whether you were successful or not.

To add permanently:

```bash
wpa_passphrase ssid password >> /etc/wpa_supplicant/wpa_supplicant.conf
```

There is a way to store the password as a hash but the procedures are out of scope right now.

**Install sudo and add a regular user**

Install sudo:

```bash
emerge --ask app-admin/sudo
```

As the documentation warns, only use visudo to edit the sudoers file:

```bash
visudo
```
Uncomment relevant line:

```bash
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

Create a regular user:

```bash
useradd -m -G users,wheel,audio -s /bin/bash larry 
```


