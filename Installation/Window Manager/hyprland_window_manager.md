## Window Manager

This area will contain instructions on instaling and configuring Hyprland.

* Hyprland
* Waybar
* Hyprpaper
* Brightnessctl
* Screen locker
* Application launcher

We begin by installing some packages:

```bash
sudo pacman -S sddm hyprland waybar hyprpaper wofi swaylock swayidle dolphin brightnessctl ttf-font-awesome polkit-kde-agent
```

**waybar**

Move config file:

```bash
sudo cp /etc/xdg/waybar ~/.config/waybar/

```

Then replace all references to sway/workspaces with hyprland/workspaces.

**brightnessctl**

Get device info:

```bash
brightnessctl info
```

Set brightness on the terminal:

```bash
brightnessctl -d "device_name" set 50%
```

Add key bindings to config file:

```bash
#~/.config/hypr/hyprland.conf
# Screen brightness
bind = , XF86MonBrightnessUp, exec, brightnessctl s +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl s 5%-
```

**Screen Locker**

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
