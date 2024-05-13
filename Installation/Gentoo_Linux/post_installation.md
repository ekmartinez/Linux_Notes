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

Assign a password:

```bash
passwd larry
```

**Installing Sway Window Manager**

First, specify your video cards in your make.conf early in the game to avoid driver problems down the road (while installing gentoo).

```bash
VIDEO_CARDS="radeon intel"
```

Lets define the use flags that ended up working (had a hard to get this working.

```bash
USE="-kde -gnome -xfce -systemd -seatd elogind wayland X"
```
```bash
emerge --ask gui-wm/sway
```

Create config files:

```bash
mkdir -p ~/.config/sway/
cp /etc/sway/config ~/.config/sway/ 
```

Start/Enable elogind service on boot:

```bash
sudo rc-update add elogind boot
```

Reboot the system, then run `sway`.

On one occation I encountered the following error message:

```bash
error: XDG_RUNTIME_DIR not set in the environment.
```

Apparently, this was caused by pam not being able to communicate correctly with elogind.  Looks like the first time I got sway installed I didn't include the elogind use flag.  This was fixed by reinstalling `sys-auth/pambase with the elogind use flag set.

**Waybar**

At the time of this writting, waybar was not working.  Using swaybar in the meantime.


**Adjust Display Brightness**

Install `xbacklight`:

```bash
 sys-power/acpilight
```

To control the brightness through the command prompt:

First add user to the video group:

```bash
sudo usermod -aG video user_name
```

To get the current brightness level:

```bash
xbacklight -get
```

To set brightness in percentage terms:

```bash
xbacklight -set 50
```

In order to control the display brightness through the keyboard,  we have to create some configurations:

`~/.config/sway/config`

```bash
bindsym XF86MonBrightnessDown exec xbacklight -dec 2
bindsym XF86MonBrightnessUp exec xbacklight -inc 4
```

`/etc/udev/rules.d/90-backlight.rules`

```bash
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"

SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
  RUN+="/bin/chgrp video /sys/class/leds/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
```

Control of brightness usign the keyboard was not working at the time of this writting.
