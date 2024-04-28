## Networking

This area will have instructions on networking operations.

* Wireless Connections
* Bluetooth Devices
* ip command
* ss command
* DNS analysis

### Wireless Connections

**iwd**

The iwctl tool allows operations on wireless devices. Note that this is better to use when installing Arch Linux or running your network configuration through systemd.  If you use Network Manager, you should use the nmcli tool instead.

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

**Network Manager**

The following are the instructions for connecting to wireless networks using Network Manager.

In case the wireless interface is off:

```bash
nmcli r wifi on
```

List available networks:

```bash
nmcli d wifi list
```

Connect to a network:
```bash
nmcli d wifi connect <ssid> password <password>
```

To deactivate connection:

```bash
nmcli con down <ssid>
```

To activate connection:

```bash
nmcli con up <ssid>
```

**Bridges**

Display connections:

```bash
nmcli con show
nmcli connection show --active 
```

Create a bridge:

```bash
sudo nmcli con add ifname br0 type bridge con-name br0
```

Add a slave:

```bash
sudo nmcli con add type bridge-slave ifname eno1 master br0
```

Confirm:

```bash
nmcli connection show
```

To turn the bridge on, you must first bring the ethernet connection down and the bring up the bridge:

Bring down ethernet:

```bash
#Assuming name: Wired connection 1
sudo nmcli con down "Wired connection 1"
```

Bring bridge up:
```bash
sudo nmcli con up br0
```

Confirm:

```bash
nmcli con show
```

## Bluetooth Connections

This area contains basic information regarding the configuration of bluetooth devices like mouse and headsets.

First of all check if the device is not block with:

```bash
rfkill list
```
If it is, unblock with:

```bash
rfkill unblock all
```

Install the necessary packages:

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
Most devices will connect back in the future, if they don't run the following:

```bash
[bluetooth]# trust <mac address>
```


