## Window Manager

This area will contain instructions on instaling and configuring Hyprland.

* Hyprland
* Waybar
* Hyprpaper
* Brightnessctl
* Screen locker
* Application launcher

**brightnessctl**

Get device info:

```bash
brightnessctl info
```

Set brightness:

```bash
brightnessctl -d "device_name" set 50%
```
**Screen Locker**

Basic setup:

Install packages

```bash
sudo pacman -Sy swaylock swayidle
```
Edit configuration file:

*~/.config/hypr/hyperland.conf*
```bash
exec-once = ~/.config/hypr/scripts/sleep.sh

$mainMod = SUPER
bind = $mainMod, L, exec, swaylock -f -c 000000
```
*~/.config/hypr/scripts/sleep.sh*
```bash
swayidle -w timeout 300 'swaylock -f -c 000000' \
            timeout 600 'hyprctl dispatch dpms off' \
            resume 'hyprctl dispatch dpms on' \
            timeout 900 'systemctl suspend' \
            before-sleep 'swaylock -f -c 000000' &
```

Make executable:

```bash
chmod +x sleep.sh
```
Lock screen with SUPER L.

**Application Launcher**

Install package:

```bash
sudo pacman -Sy wofi
```
Edit configuration file:
*~/.config/hypr/hyprland.conf*

```bash
$mainMod = SUPER
bind = $mainMod, R, exec, wofi --show drun
```
