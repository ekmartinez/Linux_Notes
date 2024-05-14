# Sway Window Manager

This section of the repo contains instructions on the installation and configuration of sway and related programs including waybar, wofi, etc.  Base configuration files are included in each program's respective folders, most of these configurations still need ricing.

Make sure you specify your video cards in your `make.conf` early in the game to avoid driver problems down the road (while installing gentoo).

```bash
VIDEO_CARDS="radeon intel"
```

Lets define some USE flags:

```bash
USE="-kde -gnome -xfce -systemd -seatd alsa pulseaudio elogind wayland X"
```

Install sway:

`/etc/portage/package.use/sway`:
```bash
gui-wm/sway wallpapers tray
>=gui-apps/swaybg-1.2.0 gdk-pixbuf
```
```bash
emerge --ask gui-wm/sway
```
Start/Enable elogind service on boot:

```bash
sudo rc-update add elogind boot
```

Reboot the system, then run `sway`.

A common error:

```bash
error: XDG_RUNTIME_DIR not set in the environment.
```

Apparently, this is caused by either of two things: elogind not been enabled by default or  pam not being able to communicate correctly with elogind. This is usually fixed by reinstalling `sys-auth/pambase with the elogind use flag set.

Create config files:

```bash
mkdir -p ~/.config/sway/
cp /etc/sway/config ~/.config/sway/ 
```

**Alacritty**

Installation:

`/etc/portage/package.use/alacritty`:

```bash
>=x11-terms/alacritty-0.12.3 -X
```
```bash
sudo emerge -av x11-terms/alacritty
```

Set Alacritty as you terminal emulator:

*`~/.config/sway/config`*

```bash
set $term alacritty
```

**Setup touchpad click support**

Get the name of the touchpad:

```bash
swaymsg -t get_inputs
```
Add to `~/.config/sway/config`:

```bash
input "2:7:SynPS/2_Synaptics_TouchPad" {
	dwt enabled
	tap enabled
	natural_scroll enabled
	middle_emulation enabled
}
```

**Application Launcher**

Install wofi:

```bash
sudo emerge -av gui-apps/wofi
```

`~/.config/sway/config`
```bash
set $menu wofi --conf=~/.config/wofi/config --style=~/.config/wofi/style.css

bindsym $mod+d exec $menu
```

**Waybar**

Installation:

`/etc/portage/package.use/waybar`
```bash
gui-apps/waybar sndio tray upower wifi network
>=dev-libs/libdbusmenu-16.04.0-r2 gtk3
```
```bash
 sudo emerge -av gui-apps/waybar
```

`~/.config/sway/config`:
```bash
bar {
	status_command waybar
	mode invisible
}
```

